{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -fdefer-type-errors #-}
{-# LANGUAGE ScopedTypeVariables #-}
import Text.HTML.Scalpel
import Data.Default (def)
import Data.Encoding
import qualified Network.Curl as Curl
import Data.Encoding.CP1256

type Author = String

data Comment
    = TextComment String
    deriving (Show, Eq)

specificDecoder :: Decoder String
specificDecoder = decodeStrictByteString CP1256 . Curl.respBody

cfg :: Config String
cfg = (def :: Config String) {decoder = specificDecoder :: Decoder String}

allComments :: IO (Maybe [Comment])
allComments = scrapeURLWithConfig cfg "http://www.4algeria.com/vb/4algeria456289/" posts
   where
     posts :: Scraper String [Comment]
     posts = chroots ("div" @: [hasClass "PostbitContainer"]) $
        (TextComment <$> (text $ "div" @: [hasClass "PostbitMessage"]))

main :: IO ()
main = do
  Just xs <- allComments
  Prelude.writeFile "results" $ Prelude.unlines [c | TextComment c <- xs]
