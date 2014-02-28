eval "$(rbenv init -)"

rubyprompt() {
  case $1 in
    on )
      export RUBY_PROMPT=1
      ;;
    off )
      export RUBY_PROMPT=0
      ;;
    * )
      if [[ $RUBY_PROMPT -eq 1 ]]; then
        export RUBY_PROMPT=0
      else
        export RUBY_PROMPT=1
      fi
      ;;
  esac
}
