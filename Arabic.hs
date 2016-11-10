{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE ScopedTypeVariables #-}
import Text.HTML.Scalpel
import Data.Default (def)
import Data.Encoding
import qualified Network.Curl as Curl
import Data.Encoding.CP1256
import System.Environment
import Control.Monad

type Author = String

data Comment
    = TextComment String
    deriving (Show, Eq)

specificDecoder :: Decoder String
specificDecoder = decodeStrictByteString CP1256 . Curl.respBody

cfg :: Config String
cfg = (def :: Config String) {decoder = specificDecoder :: Decoder String}

allComments :: String -> IO (Maybe [Comment])
allComments url = scrapeURLWithConfig cfg url posts
   where
     posts :: Scraper String [Comment]
     posts = chroots ("div" @: [hasClass "PostbitContainer"]) $
        (TextComment <$> (text $ "div" @: [hasClass "PostbitMessage"]))

main :: IO ()
main = do
  args <- getArgs
  (xs,url) <- case args of
    [url] -> do
      Just xs <- allComments url
      return (xs,url)
    [url,n] -> do
      xss <- forM [1..read n] $ \i -> do
        let url' = if i == 1 then url else url ++ "-" ++ show i
        Just xs <- allComments url'
        return xs
      return (concat xss,url)

  Prelude.writeFile ("results-" ++ (filter (/= '/') url)) $ Prelude.unlines [c | TextComment c <- xs]
