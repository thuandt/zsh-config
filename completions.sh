#!/usr/bin/env zsh

if [ $commands[argocd] ]; then
  source <(argocd completion zsh)
fi

if [ $commands[argocd-image-updater] ]; then
  source <(argocd-image-updater completion zsh)
fi

if [ $commands[caddy] ]; then
  source <(caddy completion zsh)
fi

if [ $commands[checkov] ]; then
  source <(register-python-argcomplete checkov)
fi

if [ $commands[cloud-sql-proxy] ]; then
  source <(cloud-sql-proxy completion zsh)
fi

if [ $commands[cmctl] ]; then
  source <(cmctl completion zsh)
fi

if [ $commands[cosign] ]; then
  source <(cosign completion zsh)
fi

if [ $commands[cue] ]; then
  source <(cue completion zsh)
fi

if [ $commands[docker] ]; then
  source <(docker completion zsh)
fi

if [ $commands[exercism] ]; then
  source <(exercism completion zsh)
fi

if [ $commands[flyctl] ]; then
  source <(flyctl completion zsh)
fi

if [ $commands[gh] ]; then
  source <(gh completion -s zsh)
fi

if [ $commands[glab] ]; then
  source <(glab completion -s zsh)
  compdef _glab glab
fi

if [ $commands[hugo] ]; then
  source <(hugo completion zsh)
fi

if [ $commands[infracost] ]; then
  infracost completion --shell zsh >! ${ZSH_CACHE_DIR}/completions/_infracost
fi

if [ $commands[k6] ]; then
  source <(k6 completion zsh)
fi

if [ $commands[k9s] ]; then
  source <(k9s completion zsh)
fi

if [ $commands[stern] ]; then
  source <(stern --completion=zsh)
fi

if [ $commands[opa] ]; then
  source <(opa completion zsh)
fi

if [ $commands[pipenv] ]; then
  eval "$(register-python-argcomplete pipx)"
fi

if [ $commands[pipx] ]; then
  eval "$(register-python-argcomplete pipenv)"
fi

if [ $commands[poetry] ]; then
  # fmt: off
  poetry completions zsh >! ${ZSH_CACHE_DIR}/completions/_poetry
  # fmt: on
fi

if [ $commands[yq] ]; then
  source <(yq shell-completion zsh)
fi
