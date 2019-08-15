#! /usr/bin/perl

use strict;

if ( @ARGV == 0 )
{
    print "createFeatures.pl <humann2_out_dir-1> <humann2_out_dir-2> ...\n";
}

my %geneByFeatBySamp;
my %abunByFeatBySamp;
my %coveByFeatBySamp;

my %genes;
my %abuns;
my %coves;

my %totGeneBySamp;
my %totAbunBySamp;
my @samps;

foreach my $dir ( @ARGV )
{
    $dir =~ /humann_out_(\w+?)_join/;
    my $samp = $1;
    push @samps, $samp;
    
    my $fileGenes = "$dir/${samp}_join_genefamilies.tsv";
    open GENE, $fileGenes or die "Missing $fileGenes";
    
    <GENE>; # eat header
    
    while ( <GENE> )
    {
        chomp;
        my ($gene, $val) = split /\t/;
        
        if ( $gene eq 'UNMAPPED' || $gene eq 'UniRef90_unknown' )
        {
            next;
        }
        
        if ( ! defined $geneByFeatBySamp{$samp} )
        {
            $geneByFeatBySamp{$samp} = {};
        }
        
        if ( $gene !~ /\|/ )
        {
            $totGeneBySamp{$samp} += $val;
        }
        
        $geneByFeatBySamp{$samp}{$gene} = $val;
        $genes{$gene} = 1;
    }
    
    close GENE;
    
    my $fileGenes = "$dir/${samp}_join_pathabundance.tsv";
    open ABUN, $fileGenes or die "Missing $fileGenes";
    
    <ABUN>; # eat header
    
    while ( <ABUN> )
    {
        chomp;
        my ($gene, $val) = split /\t/;
        
        if ( $gene eq 'UNMAPPED' || $gene eq 'UNINTEGRATED' || $gene eq 'UNINTEGRATED|unclassified')
        {
            next;
        }
        
        if ( ! defined $abunByFeatBySamp{$samp} )
        {
            $abunByFeatBySamp{$samp} = {};
        }
        
        if ( $gene !~ /\|/ )
        {
            $totAbunBySamp{$samp} += $val;
        }
        
        $abunByFeatBySamp{$samp}{$gene} = $val;
        $abuns{$gene} = 1;
    }
    
    close ABUN;
    
    my $fileGenes = "$dir/${samp}_join_pathcoverage.tsv";
    open COVE, $fileGenes or die "Missing $fileGenes";
    
    <COVE>; # eat header
    
    while ( <COVE> )
    {
        chomp;
        my ($gene, $val) = split /\t/;
        
        if ( $gene =~ 'UNMAPPED' || $gene eq 'UNINTEGRATED' || $gene eq 'UNINTEGRATED|unclassified')
        {
            next;
        }
        
        if ( ! defined $coveByFeatBySamp{$samp} )
        {
            $coveByFeatBySamp{$samp} = {};
        }
        
        $coveByFeatBySamp{$samp}{$gene} = $val;
        $coves{$gene} = 1;
    }
    
    close COVE;
}

foreach my $gene ( sort keys %genes )
{
    print "\tGF_$gene";
}

foreach my $gene ( sort keys %abuns )
{
    print "\tPA_$gene";
}

foreach my $gene ( sort keys %coves )
{
    print "\tPC_$gene";
}

print "\n";

foreach my $samp ( @samps )
{
    print "$samp";
    
    foreach my $gene ( sort keys %genes )
    {
        if ( defined $geneByFeatBySamp{$samp}{$gene} )
        {
            print "\t" . ($geneByFeatBySamp{$samp}{$gene} / $totGeneBySamp{$samp});
        }
        else
        {
            print "\t0";
        }
    }
    
    foreach my $gene ( sort keys %abuns )
    {
        if ( defined $abunByFeatBySamp{$samp}{$gene} )
        {
            print "\t" . ($abunByFeatBySamp{$samp}{$gene} / $totAbunBySamp{$samp});
        }
        else
        {
            print "\t0";
        }
    }
    
    foreach my $gene ( sort keys %coves )
    {
        if ( defined $coveByFeatBySamp{$samp}{$gene} )
        {
            print "\t$coveByFeatBySamp{$samp}{$gene}";
        }
        else
        {
            print "\t0";
        }
    }
    
    print "\n";
}
