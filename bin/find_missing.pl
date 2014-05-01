constant $TAGLIB  = "taglib-sharp,  Version=2.0.4.0, Culture=neutral, PublicKeyToken=db62eba44689b5b0";
constant TagLib-File    = CLR::("TagLib.File,$TAGLIB");
# constant TagLib-Tag     = CLR::("TagLib.Tag,$TAGLIB");

for lines() -> $filename {
    try {
        my $file = TagLib-File.Create($filename);
        unless $file.Tag.JoinedPerformers ~~ m/\S/ && $file.Tag.Title ~~ m/\S/ {
            say $filename;
        }
        CATCH { say "Error reading $filename" }
    }
}

# sub ConvertStringArray($a) {
#     (^$a.Length).map({ $a.Get($_) });
# }