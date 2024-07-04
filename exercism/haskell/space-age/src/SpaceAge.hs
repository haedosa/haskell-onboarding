module SpaceAge (Planet(..), ageOn) where

data Planet = Mercury
            | Venus
            | Earth
            | Mars
            | Jupiter
            | Saturn
            | Uranus
            | Neptune

ageOn :: Planet -> Float -> Float
ageOn Mercury = (/ 0.2408467) . ageOn Earth
ageOn Venus = (/ 0.61519726) . ageOn Earth
ageOn Earth = (/ 31557600)
ageOn Mars = (/ 1.8808158) . ageOn Earth
ageOn Jupiter = (/ 11.862615) . ageOn Earth
ageOn Saturn = (/ 29.447498) . ageOn Earth
ageOn Uranus = (/ 84.016846) . ageOn Earth
ageOn Neptune = (/ 164.79132) . ageOn Earth

-- >>> 3 / 7
-- 0.42857142857142855
