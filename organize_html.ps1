$dir = "c:\fluxticks_v2"
$pages = "$dir\pages"
if (!(Test-Path $pages)) { New-Item -ItemType Directory -Force -Path $pages }

$files = @("disclaimer.html", "education.html", "mentorship.html", "privacy.html", "terms.html")

foreach ($file in $files) {
    if (Test-Path "$dir\$file") { Move-Item -Force "$dir\$file" "$pages\$file" }
}

$index = "$dir\index.html"
if (Test-Path $index) {
    $content = Get-Content $index -Raw
    foreach ($file in $files) {
        $fileRegex = $file -replace '\.', '\.'
        $content = $content -replace "href=`"$fileRegex`"", "href=`"pages/$file`""
    }
    Set-Content $index $content
}

foreach ($file in $files) {
    $path = "$pages\$file"
    if (Test-Path $path) {
        $content = Get-Content $path -Raw
        $content = $content -replace 'href="css/style\.css"', 'href="../css/style.css"'
        $content = $content -replace 'src="js/script\.js"', 'src="../js/script.js"'
        $content = $content -replace 'href="assets/', 'href="../assets/'
        $content = $content -replace 'src="assets/', 'src="../assets/'
        $content = $content -replace 'href="index\.html"', 'href="../index.html"'
        Set-Content $path $content
    }
}
