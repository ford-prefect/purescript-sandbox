module Main where

import Prelude

import Control.Monad.Aff (Aff, forkAff, launchAff_)
import Control.Monad.Aff.Console (CONSOLE, log)
import Control.Monad.Eff (Eff)
import Control.Promise (Promise, toAff)

-- Sleep for n seconds
foreign import delays :: Int -> Promise Unit
-- Throw i input is 1
foreign import dieIf1 :: Int -> Int

run :: forall e. Int -> Aff (console :: CONSOLE | e) Int
run i = do
  _ <- forkAff $ do
    toAff $ delays i
    let x = dieIf1 i
    log $ "doing things: " <> show i
  pure $ i + 1

main :: forall e. Eff (console :: CONSOLE | e) Unit
main = launchAff_ $
  run 0
  >>= run
  >>= run
  >>= run
  >>= run
  >>= run
