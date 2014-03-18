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
import Control.Error.Util 
{-import Data.Strict.Either (isLeft, fromLeft)-}
import Data.Either.Utils
import Language.Haskell.Interpreter
import Control.Exception
import OpenCVLocalhost

import Options.Applicative
import LDBench.Experiments.RuntimeConfig
import LDBench.Experiments.WideBaseline.Oxford

import OpenCVThrift.OpenCV
import LDBench.Experiments.WideBaseline.Oxford
import LDBench.Experiments.WideBaseline.Experiment
import LDBench.Detectors.DoublyBoundedPairDetector
import qualified LDBench.Detectors.OpenCV as D
import qualified LDBench.Extractors.OpenCV as E
import LDBench.Matchers.Vector
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
  [ "Prelude"
  , "LDBench.Experiments.RuntimeConfig"
  , "LDBench.Experiments.WideBaseline.Oxford"
  , "LDBench.Detectors.DoublyBoundedPairDetector"
  , "LDBench.Detectors.OpenCV"
  , "LDBench.Extractors.OpenCV"
  , "LDBench.Matchers.Vector"
  ]

{-evalFromPath :: forall a. Typeable a => FilePath -> IO a-}
evalFromPath :: forall a. Typeable a => FilePath -> IO a
evalFromPath path = do
  source <- readFile path
  output <- runInterpreter $ setImports imports >> interpret source (as :: a)
  when (isLeft output) $ putStrLn $ show $ fromLeft output
  {-case output of-}
    {-Left error -> do-}
      {-putStrLn $ show error-}
      {-return $ assert False-}
    {-_ -> do-}
      {-return ()-}
  let Right value = output
  return value 
  {-liftM fromJust $ eval source imports-}

imports' :: [(String, Maybe String)]
imports' =
  [ ("Prelude", Nothing)
  , ("LDBench.Experiments.RuntimeConfig", Nothing)
  , ("LDBench.Experiments.WideBaseline.Oxford", Nothing)
  , ("LDBench.Detectors.DoublyBoundedPairDetector", Nothing)
  , ("LDBench.Detectors.OpenCV", Just "D")
  , ("LDBench.Extractors.OpenCV", Just "E")
  , ("LDBench.Matchers.Vector", Nothing)
  ]

runFromPath :: FilePath -> RuntimeConfig -> Interpreter ()
runFromPath path runtimeConfig = do
  loadModules [path]
  let moduleName = dropExtension . takeFileName $ path
  setTopLevelModules [moduleName]
  {-setImportsQ imports'-}
  {-setImports imports-}
  liftIO $ putStrLn $ "Interpreting task file."
  run <- interpret "run" (as :: RuntimeConfig -> IO ())
  liftIO $ putStrLn $ "Task file compiled."
  liftIO $ putStrLn $ "Running."
  liftIO $ run runtimeConfig
  liftIO $ putStrLn $ "Finished."

oxford = Oxford
  "boat"
  2
  10
  (DoublyBoundedPairDetector 200 100 2.0 D.BRISK)
  E.BRISK
  L0

run :: Arguments -> IO ()
run arguments = do
  foo <- runInterpreter $ setImports ["Prelude"] >> interpret "head [True,False]" (as :: Bool)
  putStrLn $ show foo
  runtimeConfig <- evalFromPath $ arguments ^. runtimeConfigPathLens :: IO RuntimeConfig
  putStrLn $ show runtimeConfig
  {-x <- runInterpreter $ runFromPath (arguments ^. experimentPathLens) runtimeConfig-}
  {-putStrLn $ show x-}
  client <- openCVClient
  results <- runOpenCVComputation (runExperiment oxford runtimeConfig) client
  putStrLn $ show results

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
