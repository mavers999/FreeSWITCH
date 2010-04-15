#!/bin/bash
##### -*- mode:shell-script; indent-tabs-mode:nil; sh-basic-offset:2 -*-
##### setup git properly for FreeSWITCH

if [ ! -d .git ]; then
  echo "error: must be run from within the top level of a FreeSWITCH git tree." 1>&2
  exit 1;
fi

err () {
  echo "error: $1" 1>&2
  exit 1
}

if ! git config user.name >/dev/null 2>&1; then
  name=$(git config user.name)
  [ -z "$name" ] \
    && [ -n "$NAME" ] && name="$NAME" || name=""
  echo -n "What is your name? [$name]: "
  read name_
  [ -n "$name_" ] && name="$name_"
  [ -z "$name" ] && err "Your name is required."
  git config --global user.name "$name"
fi

if ! git config user.email >/dev/null 2>&1; then
  email=$(git config user.email)
  [ -z "$email" ] \
    && [ -n "$EMAIL" ] && email="$EMAIL" || email=""
  echo -n "What is your email? [$email]: "
  read email_
  [ -n "$email_" ] && email="$email_"
  [ -z "$email" ] && err "Your email is required."
  git config --global user.email "$email"
fi

git config branch.master.rebase true

cat 1>&2 <<EOF
----------------------------------------------------------------------
  Git has been configured for FS successfully.

  branch.master.rebase has been set to true

    This means that when you do a 'git pull' to fetch remote changes,
    your local changes will be rebased on top of the remote changes.
    This does NOT rewrite history on the remote FS repo, but it does
    change the commit hashes in your local tree.

    If you really want to merge rather than rebasing, run:

      git merge <commit>

    See 'man git-config' for more information.
EOF

[ -n "$name" ] \
  && cat 1>&2 <<EOF

    Your name has been set to: $name

      via 'git config --global user.name "$name"
EOF

[ -n "$name" ] \
  && cat 1>&2 <<EOF

    Your email has been set to: $email

      via 'git config --global user.email "$email"
EOF

cat 1>&2 <<EOF
----------------------------------------------------------------------
EOF
