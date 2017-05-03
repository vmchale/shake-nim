#!/usr/bin/env stack
{- stack --resolver lts-8.12 --install-ghc
    runghc
    --package shake
    --package directory
-}
    
import Development.Shake
import Development.Shake.Config
import System.Directory
import Data.Maybe
import Data.Monoid

main :: IO ()
main = shakeArgs shakeOptions { shakeFiles = ".shake", shakeLint = Just LintBasic } $ do
    usingConfigFile "config/build.cfg"

    want [ "target/main"
         ]

    "clean" ~> do
        putNormal "cleaning files..." 
        removeFilesAfter "nimcache" ["//*"]

    "configure" ~> do
        source <- fromMaybe [] <$> getConfig "LIB_DEPENDS"
        putNormal "installing dependencies..."
        cmd ["nimble", "install", "nimx"]

    "target/main" %> \out -> do
        source <- fromMaybe "src" <$> getConfig "SRC_DIR"
        liftIO $ createDirectoryIfMissing True "target"
        liftIO $ createDirectoryIfMissing True ".nim"
        unit $ cmd (Cwd ".nim") ["ln", "-sf", source <> "/main.nim", ".nim/main"]
        unit $ cmd (AddEnv "NIMX_RES_PATH" "123") (Cwd ".nim") ["nim", "c", "-r", "/main.nim"]
        cmd ["ln", "-sf", ".nim/main", "target/main"]
