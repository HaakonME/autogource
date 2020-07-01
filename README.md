# autogource
Autogource - create video from git log including submodules with Gource without the effort

By Haakon Meland Eriksen (2020)

Based on derEremit's wonderful script (?) or anonymous, which was nearly there, see https://gist.github.com/derEremit/1347949 .

My improvement is to remove the need for subrepo paths as command line arguments - in my case, 95 arguments, Moodle as main repo and every module as a git submodule. Enjoy! :-)

# Requirements
- Bash 4+
- Git
- AWK
- Gource - https://gource.io/ and https://github.com/acaudwell/Gource
- FFMPEG

# HOWTO
Save autogource.sh in the top repo with all the git submodules below, chmod +x autogource.sh, then run ./autogource.sh
