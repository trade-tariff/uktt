{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-ruby = {
      url = "github:bobvanderlinden/nixpkgs-ruby";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      pre-commit-hooks,
      nixpkgs-ruby,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ nixpkgs-ruby.overlays.default ];
        };

        rubyVersion = builtins.head (builtins.split "\n" (builtins.readFile ./.ruby-version));
        ruby = pkgs."ruby-${rubyVersion}";

        psychBuildFlags = with pkgs; [
          "--with-libyaml-include=${libyaml.dev}/include"
          "--with-libyaml-lib=${libyaml.out}/lib"
        ];

        reviewTools = import (builtins.fetchTree {
          type = "github";
          owner = "NixOS";
          repo = "nixpkgs";
          rev = "0d534853a55b5d02a4ababa1d71921ce8f0aee4c";
          narHash = "sha256-IDtwLhWMKvydW9GrB6ETwhij+vma0hYHln8pR/rTd+U=";
        }) { inherit system; };
        reviewSecretTools = import (builtins.fetchTree {
          type = "github";
          owner = "NixOS";
          repo = "nixpkgs";
          rev = "a421ac6595024edcfbb1ef950a3712b89161c359";
          narHash = "sha256-Nz2vtUEaRB/UjvPfuhHpez060P/4mvGpXW4JCDIboA4=";
        }) { inherit system; };
        reviewRubyHooks = builtins.fetchTree {
          type = "github";
          owner = "mattlqx";
          repo = "pre-commit-ruby";
          rev = "1f893f2c0db4068fafa19b8ea7d7db1253ea0cc1";
          narHash = "sha256-7S84RvncmcXVIjgNhzFyN4HnKJk+tKxHYvfOLcuiw8c=";
        };
        reviewPreCommitConfig = pkgs.writeText "review-pre-commit.json" (
          builtins.toJSON {
            repos = [
              {
                repo = "local";
                hooks = [
                  {
                    id = "trailing-whitespace";
                    name = "trim trailing whitespace";
                    language = "system";
                    entry = "${reviewTools.python3Packages.pre-commit-hooks}/bin/trailing-whitespace-fixer";
                    types = [ "text" ];
                    stages = [
                      "pre-commit"
                      "pre-push"
                      "manual"
                    ];
                  }
                  {
                    id = "end-of-file-fixer";
                    name = "fix end of files";
                    language = "system";
                    entry = "${reviewTools.python3Packages.pre-commit-hooks}/bin/end-of-file-fixer";
                    types = [ "text" ];
                    stages = [
                      "pre-commit"
                      "pre-push"
                      "manual"
                    ];
                  }
                  {
                    id = "check-yaml";
                    name = "check yaml";
                    language = "system";
                    entry = "${reviewTools.python3Packages.pre-commit-hooks}/bin/check-yaml";
                    types = [ "yaml" ];
                  }
                  {
                    id = "trufflehog";
                    name = "TruffleHog";
                    language = "system";
                    entry = "${reviewSecretTools.trufflehog}/bin/trufflehog git file://. --since-commit HEAD --results=verified --fail";
                    pass_filenames = false;
                  }
                  {
                    id = "rubocop";
                    name = "Check Ruby style with rubocop";
                    language = "system";
                    entry = "${reviewRubyHooks}/bin/rubocop-wrapper.sh";
                    args = [ "--auto-correct" ];
                    pass_filenames = true;
                    types = [ "ruby" ];
                  }
                  {
                    id = "actionlint-docker";
                    name = "Lint GitHub Actions workflow files";
                    language = "system";
                    entry = "${reviewTools.actionlint}/bin/actionlint";
                    types = [ "yaml" ];
                    files = "^\\.github/workflows/";
                  }
                ];
              }
            ];
          }
        );
        reviewEnvironment = ''
          if [ "''${REVIEW_SANDBOX:-}" != 1 ] || [ "$PWD" != /workspace ]; then
            echo 'Run review commands inside a disposable review sandbox.' >&2
            exit 64
          fi
          export TMPDIR=/workspace/.review/tmp PRE_COMMIT_HOME=/workspace/.review/pre-commit
          export GEM_HOME=/workspace/.review/gems
          export GEM_PATH="$GEM_HOME''${REVIEW_GEM_CACHE:+:$REVIEW_GEM_CACHE}"
          export BUNDLE_IGNORE_CONFIG=1 BUNDLE_PATH__SYSTEM=true
          export PATH="$GEM_HOME/bin:$PATH" BUNDLE_BIN="$GEM_HOME/bin"
          unset BUNDLE_PATH BUNDLE_APP_CONFIG BUNDLE_WITHOUT
          mkdir -p "$TMPDIR" "$GEM_HOME"
        '';

        preCommitCheck = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          configPath = ".pre-commit-config-nix.yaml";
          default_stages = [ "pre-commit" ];
          hooks = {
            actionlint = {
              enable = true;
              stages = [ "pre-commit" ];
            };
            check-added-large-files = {
              enable = true;
              stages = [ "pre-commit" ];
            };
            check-case-conflicts = {
              enable = true;
              stages = [ "pre-commit" ];
            };
            check-merge-conflicts = {
              enable = true;
              stages = [ "pre-commit" ];
            };
            check-yaml = {
              enable = true;
              stages = [ "pre-commit" ];
            };
            deadnix = {
              enable = true;
              stages = [ "pre-commit" ];
            };
            detect-private-keys = {
              enable = true;
              stages = [ "pre-commit" ];
            };
            end-of-file-fixer = {
              enable = true;
              stages = [ "pre-commit" ];
            };
            nixfmt-rfc-style = {
              package = pre-commit-hooks.inputs.nixpkgs.legacyPackages.${system}.nixfmt;
              enable = true;
              stages = [ "pre-commit" ];
            };
            statix = {
              enable = true;
              settings.ignore = [ "{.direnv,.nix,.worktrees}/**" ];
              stages = [ "pre-commit" ];
            };
            trim-trailing-whitespace = {
              enable = true;
              stages = [ "pre-commit" ];
            };
            trufflehog = {
              enable = true;
              stages = [ "pre-commit" ];
            };

            rubocop = {
              enable = true;
              name = "rubocop";
              description = "Run RuboCop through Bundler on changed Ruby files";
              entry = ''
                bash -c '
                  changed_files=$(git diff --name-only --diff-filter=ACM --merge-base main | grep -E "\\.(rb|rake)$|^(Gemfile|Rakefile|config\\.ru)$" || true)

                  if [ -n "$changed_files" ]; then
                    bundle exec rubocop --autocorrect --force-exclusion $changed_files
                  fi
                '
              '';
              files = "\\.(rb|rake)$|^(Gemfile|Rakefile|config\\.ru)$";
              pass_filenames = false;
              stages = [ "pre-commit" ];
            };
          };
        };

        preCommit = pkgs.writeShellScriptBin "pre-commit" ''
          set -euo pipefail

          has_config=false
          for arg in "$@"; do
            case "$arg" in
              -c|--config|--config=*)
                has_config=true
                ;;
            esac
          done

          if [ "$has_config" = true ]; then
            exec ${preCommitCheck.config.package}/bin/pre-commit "$@"
          fi

          if [ "''${1:-}" = "run" ]; then
            shift
            exec ${preCommitCheck.config.package}/bin/pre-commit run --config .pre-commit-config-nix.yaml "$@"
          fi

          exec ${preCommitCheck.config.package}/bin/pre-commit "$@"
        '';
      in
      {
        devShells.review = self.devShells.${system}.default.overrideAttrs (old: {
          shellHook = "";
          nativeBuildInputs = [
            pkgs.gitMinimal
            reviewTools.pre-commit
            (pkgs.writeShellApplication {
              name = "review-bootstrap";
              text = reviewEnvironment + ''
                if [ -d /deps/gem-archives ]; then
                  for archive in /deps/gem-archives/*.gem; do
                    [ -f "$archive" ] || continue
                    gem install --local --no-document --ignore-dependencies "$archive"
                  done
                fi
                bundle check || bundle install --local
                bundle binstubs rubocop
              '';
            })
            (pkgs.writeShellApplication {
              name = "review-check";
              text = reviewEnvironment + ''
                status=0
                pre-commit run --all-files --config ${reviewPreCommitConfig} || status=$?
                bundle exec rubocop || status=$?
                echo 'The RSpec suite uses the shared staging API; full qualification requires live API access.' >&2
                if [ "$status" -ne 0 ]; then exit "$status"; fi
                exit 78
              '';
            })
          ]
          ++ (old.nativeBuildInputs or [ ]);
          BUNDLE_BUILD__PSYCH = builtins.concatStringsSep " " psychBuildFlags;
          TZDIR = "${pkgs.tzdata.outPath}/share/zoneinfo";
          SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        });

        devShells.default = pkgs.mkShell {
          shellHook = ''
            export GEM_HOME=$PWD/.nix/ruby/$(${ruby}/bin/ruby -e "puts RUBY_VERSION")
            mkdir -p $GEM_HOME

            export BUNDLE_BUILD__PSYCH="${builtins.concatStringsSep " " psychBuildFlags}"

            export GEM_PATH=$GEM_HOME
            export PATH=$GEM_HOME/bin:$PATH
            ${preCommitCheck.shellHook}
            export PATH=${preCommit}/bin:$PATH
          '';

          buildInputs = preCommitCheck.enabledPackages ++ [
            ruby
          ];
        };
      }
    );
}
