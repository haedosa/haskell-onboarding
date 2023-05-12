{-# LANGUAGE ImportQualifiedPost #-}
{-# OPTIONS_GHC -Wno-noncanonical-monad-instances #-}

module ExactlyOne where

import Control.Applicative qualified as A
import Control.Monad qualified as M


newtype ExactlyOne a = ExactlyOne a deriving (Eq, Show)

runExactlyOne :: ExactlyOne a -> a
runExactlyOne (ExactlyOne a) = a

mapExactlyOne :: (a -> b) -> ExactlyOne a -> ExactlyOne b
mapExactlyOne f (ExactlyOne a) = ExactlyOne (f a)

bindExactlyOne :: (a -> ExactlyOne b) -> ExactlyOne a -> ExactlyOne b
bindExactlyOne f (ExactlyOne a) = f a

instance Functor ExactlyOne where
  fmap = M.liftM

instance Applicative ExactlyOne where
  (<*>) = M.ap
  pure = ExactlyOne

instance Monad ExactlyOne where
  (>>=) = flip bindExactlyOne
  return = ExactlyOne
