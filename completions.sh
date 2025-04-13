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

if [ $commands[exercism] ]; then
  source <(exercism completion zsh)
fi

if [ $commands[flyctl] ]; then
  source <(flyctl completion zsh)
fi

if [ $commands[glab] ]; then
  source <(glab completion -s zsh)
  compdef _glab glab
fi

if [ $commands[hugo] ]; then
  source <(hugo completion zsh)
fi

if [ $commands[infracost] ]; then
  source <(infracost completion --shell zsh)
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

if [ $commands[yq] ]; then
  source <(yq shell-completion zsh)
fi
