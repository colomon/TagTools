my $for-real = Bool::True;#False;

constant $TAGLIB  = "taglib-sharp,  Version=2.0.4.0, Culture=neutral, PublicKeyToken=db62eba44689b5b0";
constant TagLib-File    = CLR::("TagLib.File,$TAGLIB");
constant String-Array   = CLR::("System.String[]");
# constant TagLib-Tag     = CLR::("TagLib.Tag,$TAGLIB");

for lines() -> $filename {
    my @path-parts = $filename.split('/').map(&Scrub);
    # say @path-parts.perl;
    my $number-and-title = @path-parts.pop;
    next unless $number-and-title ~~ m/(\d+) \- (.*) .mp3/;
    my $track-number = ~$0;
    my $title = ~$1;
    my $album = @path-parts.pop;
    my $artist = @path-parts.pop;
    say "$artist: $album: $title (track $track-number)";

    if $for-real {
        my $file;
        try {
            $file = TagLib-File.Create($filename);
            CATCH { say "Error reading $filename" }
        }

        $file.Tag.Track = $track-number.Int;
        $file.Tag.Album = $album;
        $file.Tag.Title = $title;
        $file.Tag.Performers = MakeStringArray($artist);
        
        try {
            $file.Save;
            CATCH { say "Error saving changes to $filename" }
        }
    }
}

sub Scrub($a) {
    $a.subst('_', ' ', :global);
}

# sub ConvertStringArray($a) {
#     (^$a.Length).map({ $a.Get($_) });
# }

sub MakeStringArray(Str $a) {
    my $sa = String-Array.new(1);
    $sa.Set(0, $a);
    $sa;
}