function go-build-multi
    set -l project_name (basename (pwd))
    set -l tool_version (git describe --tags ^/dev/null; or echo "dev")

    echo "📦 Building $project_name version: $tool_version"

    for os in linux windows darwin
        set -l ext ""
        set -l folder ""

        switch $os
            case linux
                set folder linux
            case windows
                set folder windows
                set ext ".exe"
            case darwin
                set folder macos
        end

        set -l output_dir dist/$folder
        mkdir -p $output_dir

        set -l outfile "$output_dir/$project_name$ext"

        echo "🔧 Building for $os..."
        env GOOS=$os GOARCH=amd64 go build -ldflags "-s -w -X main.version=$tool_version" -o $outfile .

        if test $status -eq 0
            echo "✅ Built: $outfile"
            if type -q upx
                upx --best --lzma $outfile
            end

            # 🔒 Zippage
            set -l zipfile "dist/$project_name-$os.zip"
            echo "📦 Zipping: $zipfile"
            zip -j $zipfile $outfile >/dev/null
            if test $status -eq 0
                echo "✅ Created zip: $zipfile"
            else
                echo "❌ Failed to zip $outfile"
            end
        else
            echo "❌ Failed to build for $os"
        end
    end

    echo "🎉 All builds and zips completed in dist/"
end
