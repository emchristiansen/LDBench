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

import Options.Applicative

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

runtimeConfigParser :: Parser String
runtimeConfigParser = Options.Applicative.argument str (metavar "Hi" <> help "Blah")

declareFields [d|
  data Foo = Foo
    { bar :: Int
    }
  |]

{-data Arguments = Arguments -}
  {-{ _argumentsCodeTypeL :: CodeType-}
  {-, _argumentsLanguageL :: Language-}
  {-, _argumentsInterfaceRootL :: InterfaceRoot-}
  {-, _argumentsOutputRootL :: OutputRoot-}
  {-} deriving (Show)-}
{-makeFields ''Arguments-}

{-argumentsParser :: FilePath -> Parser Arguments-}
{-argumentsParser pwd = Arguments-}
  {-<$> codeTypeParser -}
  {-<*> languageParser-}
  {-[><*> (InterfaceRoot <$> strOption<]-}
    {-[>(long "interface-root" <> help "Root directory of Thrift interface."))<]-}
  {-<*> (InterfaceRoot . (combine pwd) <$> Options.Applicative.argument str -}
    {-(metavar "INTERFACE_ROOT" <> help "Root directory of Thrift interface."))-}
  {-<*> (OutputRoot . (combine pwd) <$> Options.Applicative.argument str -}
    {-(metavar "OUTPUT_ROOT" <> help "Root directory for generated code."))-}
  {-[><*> (OutputRoot <$> strOption<]-}
    {-[>(long "output-root" <> help "Root directory for generated code."))<]-}

{-run :: Arguments -> IO ()-}
{-run (Arguments ImplementationStub Cpp interfaceRoot outputRoot) = -}
  {-cppServer interfaceRoot outputRoot-}
{-run (Arguments Client Cpp interfaceRoot outputRoot) = -}
  {-cppClient interfaceRoot outputRoot-}
{-run (Arguments Client Python interfaceRoot outputRoot) = -}
  {-pyClient interfaceRoot outputRoot-}
{-run (Arguments Client Haskell interfaceRoot outputRoot) = -}
  {-hsClient interfaceRoot outputRoot-}
{-run _ = putStrLn "Not implemented yet."-}

{-description :: String-}
{-description = unlines-}
  {-[ "Generate either the server-side stub or client library code for a given language."-}
  {-, "  Takes a directory containing a Thrift interface and dumps the generated code into the output directory."-}
  {-]-}

{-opts :: FilePath -> ParserInfo Arguments -}
{-opts pwd = info (argumentsParser pwd <**> helper)-}
  {-( fullDesc-}
 {-<> progDesc description -}
 {-<> header "Thriftier: Wraps a bit of Apache Thrift and makes it a bit nicer." )-}

main :: IO ()
main = do
  pwd <- getCurrentDirectory 
  undefined
  {-execParser (opts pwd) >>= run-}