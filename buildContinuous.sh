run() {
  #cabal clean &&
  #sh configure.sh &&
  cabal build
  cabal haddock --verbose=0 --executables
}

while inotifywait -qq -r -e modify .; do run; echo "Done"; done
