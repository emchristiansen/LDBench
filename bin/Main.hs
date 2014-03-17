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
{-import System.Eval.Haskell-}
import Data.Typeable
import Language.Haskell.Interpreter

import Options.Applicative
import LDBench.Experiments.RuntimeConfig
import LDBench.Experiments.WideBaseline.Oxford

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

{-declareFields [d|-}
  {-data Arguments = Arguments-}
    {-{ _runtimeConfigPath :: FilePath-}
    {-, _experimentPath :: FilePath-}
    {-}-}
  {-|]-}
data Arguments = Arguments
  { _argumentsRuntimeConfigPathLens :: FilePath
  , _argumentsExperimentPathLens :: FilePath
  }
makeFields ''Arguments

argumentsParser :: FilePath -> Parser Arguments
argumentsParser pwd = Arguments
  <$> ((combine pwd) <$> Options.Applicative.argument str 
    (metavar "RUNTIME_CONFIG_PATH" <> help "Path to runtime config, which encodes environment information needed to run LDBench."))
  <*> ((combine pwd) <$> Options.Applicative.argument str 
    (metavar "EXPERIMENT_PATH" <> help "Path to experiment definition."))

imports :: [String]
imports =
  [ "LDBench.Experiments.RuntimeConfig"
  , "LDBench.Experiments.WideBaseline.Oxford"
  , "LDBench.Detectors.DoublyBoundedPairDetector"
  , "LDBench.Detectors.OpenCV"
  , "LDBench.Extractors.OpenCV"
  , "LDBench.Matchers.Vector"
  ]

evalFromPath :: Typeable a => FilePath -> IO a
evalFromPath path = do
  undefined
  {-source <- readFile path-}
  {-liftM fromJust $ eval source imports-}

{-foo = do-}
  {-_ <- setImports ["Prelude"]-}
  {-interpret "head [True, False]" (as :: Bool)-}

run :: Arguments -> IO ()
run arguments = do
  foo <- runInterpreter $ setImports ["Prelude"] >> interpret "head [True,False]" (as :: Bool)
  putStrLn $ show foo
  {-runtimeConfig <- evalFromPath $ arguments ^. runtimeConfigPathLens :: IO RuntimeConfig-}
  {-putStrLn $ show runtimeConfig-}
  {-i <- unsafeEval "1 + 6 :: Int" [] :: IO (Maybe Int)-}
  {-putStrLn $ show i-}
  {-experiment <- evalFromPath $ arguments ^. experimentPathLens :: IO String-}
  {-putStrLn $ show experiment -}
  undefined

description :: String
description = unlines
  [ "Run the given experiment with the given runtime config."
  ]

opts :: FilePath -> ParserInfo Arguments 
opts pwd = info (argumentsParser pwd <**> helper)
  ( fullDesc
 <> progDesc description 
 <> header "LDBench: A test framework for local descriptors." )

main :: IO ()
main = do
  pwd <- getCurrentDirectory 
  execParser (opts pwd) >>= run
