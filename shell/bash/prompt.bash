PROMPT_COMMAND='status=$(cache_exit_status);
PS1="$(update_titlebar)\n${hist_num} ${user_sys_info} ${time_stamp}$(jobs_count)
$(display_project_env)${cwd_path} $(main_prompt $status)${RESET} "'
