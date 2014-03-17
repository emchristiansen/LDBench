import System.Environment
import System.FilePath.Glob
import System.FilePath.Find
{-import System.Process-}
import System.Cmd
import System.FilePath.Posix
import Text.Printf
import Text.Regex
import System.Directory
import Control.Lens
import Control.Monad
import System.Eval.Haskell
import Data.Typeable

import Options.Applicative
import LDBench.Experiments.RuntimeConfig

{-data CodeType = ImplementationStub | Client deriving (Eq, Show)-}

{-implementationStubParser :: Parser CodeType-}
{-implementationStubParser = flag' ImplementationStub (long "stub")-}

{-clientStubParser :: Parser CodeType-}
{-clientStubParser = flag' Client (long "client")-}

{-codeTypeParser :: Parser CodeType-}
{-codeTypeParser = implementationStubParser <|> clientStubParser-}

{-data Language = Cpp | Python | Haskell deriving (Eq, Show)-}

{-cppParser :: Parser Language-}
{-cppParser = flag' Cpp (long "cpp")-}

{-pythonParser :: Parser Language-}
{-pythonParser = flag' Python (long "python")-}

{-haskellParser :: Parser Language-}
{-haskellParser = flag' Haskell (long "haskell")-}

{-languageParser :: Parser Language-}
{-languageParser = cppParser <|> pythonParser <|> haskellParser-}

declareFields [d|
  data Arguments = Arguments
    { runtimeConfigPath :: FilePath
    }
  |]

argumentsParser :: FilePath -> Parser Arguments
argumentsParser pwd = Arguments
  <$> ((combine pwd) <$> Options.Applicative.argument str 
    (metavar "RUNTIME_CONFIG" <> help "Path to runtime config."))

evalFromPath :: Typeable a => FilePath -> IO a
evalFromPath path = do
  source <- readFile path
  liftM fromJust $ eval source []

run :: Arguments -> IO ()
run arguments = do
  runtimeConfig <- evalFromPath $ arguments ^. runtimeConfigPathLens :: IO RuntimeConfig
  putStrLn $ show runtimeConfig
  undefined

description :: String
description = unlines
  [ "Generate either the server-side stub or client library code for a given language."
  , "  Takes a directory containing a Thrift interface and dumps the generated code into the output directory."
  ]

opts :: FilePath -> ParserInfo Arguments 
opts pwd = info (argumentsParser pwd <**> helper)
  ( fullDesc
 <> progDesc description 
 <> header "Thriftier: Wraps a bit of Apache Thrift and makes it a bit nicer." )

main :: IO ()
main = do
  pwd <- getCurrentDirectory 
  execParser (opts pwd) >>= run
