#!/bin/bash
# Autogource - create video from git log including submodules with Gource without the effort
# by Haakon Meland Eriksen.
# Based on derEremit's wonderful script (?) or anonymous, which was nearly there. 
# My improvement is to remove the need for subrepo paths as command line arguments - in my case, 95 arguments. 8-) Enjoy! :-)
# HOWTO: save autogource.sh in the top repo with all the git submodules below, chmod +x gource.sh, then run ./autogource.sh

# Get submodules paths into array

submodules=($(git config --file .gitmodules --get-regexp path | awk '{ print $2 }'))

# Include main repo by adding main repo as a path into the array of submodules
submodules+=('.')

# Loop through all repos in array and create temporary logfiles for gource for each repo
for submodule in "${submodules[@]}"
do
	logfile="$(mktemp /tmp/gource.XXXXXX)"
	gource --output-custom-log "${logfile}" ${submodule}
	logs[$i]=$logfile
	let i=$i+1
done


# Combine all logs into one log, sorting timestamps from first to last, then delete temporary logfiles
combined_log="$(mktemp /tmp/gource.XXXXXX)"
cat ${logs[@]} | sort -n > $combined_log
rm ${logs[@]}

# Echo uniq contributors to source
echo "Committers:"#cat $combined_log | awk -F\| {'print  $2'} | sort | uniq
echo "======================"

# Set filename for gource video
outfile="gource.mp4"

# Set title in gource video
# title="The Moodle Community - 2001-2020 and beyond"
# -- title $title \ below does NOT work yet.

# Start gource with combined log as input with the following gource options,
# then pipe to ffmpeg to create a video with the name given in outfile above.
time gource $combined_log \
	-s 0.2 \
	-i 0 \
	-1280x720 \
	--highlight-users \
	--highlight-dirs \
	--file-extensions \
	--hide mouse \
	--key \
	--stop-at-end \
	--title "Growing the Moodle Community - 2001-2020 and beyond" \
	--output-ppm-stream - | ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libx264 -preset ultrafast -pix_fmt yuv420p -crf 1 -threads 0 -bf 0 $outfile

# Delete the combined log to clean up.	
rm $combined_log
