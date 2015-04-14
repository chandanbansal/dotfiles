#!/usr/bin/perl -w
#
# colorize.pl
# Author      - Samuel Benzaquen
# Modified by - Ashish Poddar
#

use Term::ANSIColor;
use Getopt::Std;

use strict;

#my $DEFAULT_DATA_DIR = "$ENV{HOME}/.colorize.data";
my $DEFAULT_DATA_DIR = "$ENV{DOTFILES}/.colorize.data";

sub usage();
sub load_file($);
sub match_input();
sub is_option($$);

# Command-line options
our($opt_f, $opt_s, $opt_d, $opt_h, $opt_i);
getopts('f:sdhi');

our @loaded_files;
# Choose the correct format file. Either locally
# (relative or absolute path) or from the default
# repository
# Try different file name syntaxes
sub try_load_file($) {
    my $root_file_name = shift;
    my $file_name;
    if (defined $root_file_name){
        my @possible_names = ($root_file_name,
"${root_file_name}_format.txt",
"${DEFAULT_DATA_DIR}/${root_file_name}",
"${DEFAULT_DATA_DIR}/${root_file_name}_format.txt");
        for my $name (@possible_names){
            print "Trying format file $name\n" if $opt_d;
            if (-f $name){
                $file_name = $name;
                load_file($file_name);
                last;
            }
        }
    }
}
try_load_file($opt_f);

# Check the format file
if ($opt_h or $#loaded_files == -1){
    usage();
    exit 1;
}

# Log the username of the people who uses it =)
`whoami | cat $DEFAULT_DATA_DIR/.users - | sort -u > $DEFAULT_DATA_DIR/.users.tmp`;
`cat < $DEFAULT_DATA_DIR/.users.tmp > $DEFAULT_DATA_DIR/.users`;

# The output colors and format. The keys are the regular expressions.
our %regexp_options;
our @regexps;

match_input();

sub is_option($$){
    my $regexp = shift;
    my $option = shift;
    my $options = $regexp_options{$regexp};
    return ($$options{options} =~ /\W${option}\W/);
}

sub load_file($){
    my $this_file_name = shift;
    my @pending_includes;
    return if (not -f "$this_file_name" or (grep {$_ eq $this_file_name} @loaded_files));
    push @loaded_files, $this_file_name;
     # File format to read
    print "Loading format file $this_file_name\n" if $opt_d;
    my $FORMAT_FILE;
    open FORMAT_FILE, $this_file_name;
    # Load the format from the file
    my $error_loading = 0;
    while(<FORMAT_FILE>){
        if (my ($includeFile) = /^\s*\#\s*include\s+(\S+)/x) {
            push @pending_includes, $includeFile;
            next;
        }
        next if (/^\s*\#/); # Lines with comments
        next if (/^\s*$/);  # Empty lines
        if (my ($regexp, $outexp, $colors, $options) =
                /^
                # The pattern to match
                (.*?)\s*
                # The output pattern
                =\s*\{(.*?)\}\s*
                # The colors
                (?:=\s*\{([\w\,\s]*)\}\s*
                # The options
                (?:=\s*(\{[\w\,\s]*\}))?)?
                $/x){
            push @regexps, $regexp;
            $regexp_options{$regexp} = {
                colors => ($colors or ''),
                format => ($outexp or ''),
                options => ($options or ''),
            };
        }
        else {
            print STDERR "Error loading rule: $_";
            $error_loading = 1;
        }
    }
    close FORMAT_FILE;

    foreach (@pending_includes) {
        try_load_file($_);
    }

    die 'Errors in format file' if $error_loading and not $opt_i;
}

sub match_input(){
    # Variable to allow extra line between matched and not matched output
    my $last_matched = 1;

    # Read all the input from STDIN
    while (my $line = <STDIN>){
        my $matched = 0;
        my $should_print = 0;
        my $work_line = $line;
        my $to_stdout = 1;

        for my $regexp (@regexps){
            if (my @chunks = $work_line =~ m!$regexp!g){
                my $options = $regexp_options{$regexp};
                my @colors = split /,/, $$options{colors};

                # Create colored chunks
                my $limit = (is_option($regexp, 'NoFormat')) ? $#chunks : $#colors;
                print $limit . "\n" if ($opt_d);
                foreach my $i (0..$limit){
                    $chunks[$i] = (color $colors[$i % ($#colors + 1)]) . $chunks[$i] .
                        (color 'reset');
                }

                # Save in case of NoFormat option
                my ($before, $after) = ("$`", "$'");

                # Substitute the output with the chunks
                if (is_option($regexp, 'NoFormat')){
                    #$work_line = "$before" . join('',@chunks) . "$after";
                    $work_line = join('',@chunks) . "$after";
                }
                else {
                    $work_line = $$options{format};
                    $work_line =~ s#\\(\d+)#$chunks[$1-1]#g;
                }
                chomp $work_line;

                if (is_option($regexp, 'DontMarkMatched')) {
                    $should_print = 1;
                } else {
                    $matched = 1;
                }

                $to_stdout = not is_option($regexp, 'STDERR');

                # Just process the first match
                last unless is_option($regexp, 'Continue');
            }
        }

# TODO: Need to add printing to stderr in case 'not $to_stdout'
        # Print out the line
        if ($matched and scalar $work_line){
            print "\n" if not $last_matched;
            $last_matched = 1;

            print $work_line . "\n";
        }
        # Print the line anyway if:
        #  - In debug mode
        #  - Not matched and skip option is not on
        if ($opt_d or ((not $matched) and (not $opt_s))){
            print "\n" if $last_matched;
            if ($should_print) {
                print $work_line . "\n";
            } else {
                print $line;
            }
            $last_matched = 0;
        }
    }
}

sub usage(){
    print STDERR "$0 -f <pattern_file> [-shdi]\n";
    print STDERR "\t-s : Skip not matched lines\n";
    print STDERR "\t-d : Print all lines (Debug mode)\n";
    print STDERR "\t-i : Ignore errors in the format file\n";
    print STDERR "\t-h : Print this help\n";
}
