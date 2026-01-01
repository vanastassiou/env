# shellcheck shell=bash
# shellcheck disable=SC2034 # Expected behavior for themes.

SCM_THEME_PROMPT_DIRTY=" ${red?}✗"
SCM_THEME_PROMPT_CLEAN=" ${bold_green?}✓"
SCM_THEME_PROMPT_PREFIX=" ${green?}|"
SCM_THEME_PROMPT_SUFFIX="${green?}|"

GIT_THEME_PROMPT_DIRTY=" ${red?}✗"
GIT_THEME_PROMPT_CLEAN=" ${bold_green?}✓"
GIT_THEME_PROMPT_PREFIX=" ${green?}|"
GIT_THEME_PROMPT_SUFFIX="${green?}|"

VIRTUALENV_THEME_PROMPT_PREFIX="${green?}ⓔ "
VIRTUALENV_THEME_PROMPT_SUFFIX=" "

NEWLINE=$'\n'

python_env_dir="${VIRTUAL_ENV:-$CONDA_DEFAULT_ENV}"
python_env="${python_env_dir##*/}"

function prompt_command() {
	PS1="${NEWLINE}"
  PS1+="[ $(clock_prompt) ${reset_color?}] "
	PS1+="${yellow?}$(python_version_prompt) "
  PS1+="${cyan?}\u"
  PS1+="${white?} @ "
	PS1+="${purple?}\h "
	PS1+="${reset_color?}in "
	PS1+="${green?}\w${NEWLINE}"
	PS1+="${green?}$(scm_prompt_char_info) "
	PS1+="${green?}→${reset_color?} "
}

: "${THEME_SHOW_CLOCK_CHAR:="true"}"
: "${THEME_CLOCK_CHAR_COLOR:=${red?}}"
: "${THEME_CLOCK_COLOR:=${white?}}"
: "${THEME_CLOCK_FORMAT:="%Y-%m-%d %H:%M:%S"}"

safe_append_prompt_command prompt_command
