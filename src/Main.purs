module Main where

--import Aff (runAff)
import Generic (runGeneric)

import Prelude

import Effect (Effect)

main :: Effect Unit
main = do
  runGeneric
  --runAff
