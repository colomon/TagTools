constant $TAGLIB  = "taglib-sharp,  Version=2.0.4.0, Culture=neutral, PublicKeyToken=db62eba44689b5b0";
constant TagLib-File    = CLR::("TagLib.File,$TAGLIB");
constant String-Array   = CLR::("System.String[]");
# constant TagLib-Tag     = CLR::("TagLib.Tag,$TAGLIB");

my $track-number = 1;
my @tracks = lines;
for @tracks -> $filename {
    my $file;
    try {
        $file = TagLib-File.Create($filename);
        CATCH { say "Error reading $filename"; next; }
    }

    my $new-filename = sprintf("%02d-", $file.Tag.Track) 
                       ~ $file.Tag.Title.subst(/ \s | '?' | "'" | '(' | ')' | '"' | '#' /, "_", :global)
                       ~ ".mp3";
    $new-filename .= subst(/"&"/, "and", :global);
    $new-filename .= subst(rx{'/'}, "-", :global);
    say "mv " ~ $filename.perl ~ " "  ~ $new-filename;
}
