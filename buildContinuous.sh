run() {
  #cabal clean &&
  #sh configure.sh &&
  cabal build
  cabal haddock
}

while inotifywait -qq -r -e modify .; do run; echo "Done"; done
