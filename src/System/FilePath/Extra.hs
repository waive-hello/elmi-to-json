module System.FilePath.Extra
  ( findAll
  , maybeMakeRelative
  , dasherize
  ) where

import qualified Data.List as L
import qualified Data.Text as T
import qualified System.Directory as Dir
import System.FilePath (FilePath, (<.>), (</>))
import qualified System.FilePath as F

findAll :: T.Text -> FilePath -> IO [FilePath]
findAll extension dir = do
  contents <- Dir.getDirectoryContents dir
  let found =
        filter ((==) ("" <.> T.unpack extension) . F.takeExtension) contents
  return $ fmap (dir </>) found

maybeMakeRelative :: FilePath -> FilePath -> Maybe FilePath
maybeMakeRelative file dir =
  if file `L.isPrefixOf` dir
    then Just (F.makeRelative dir file)
    else Nothing

dasherize :: FilePath -> T.Text
dasherize =
  T.intercalate "-" . fmap T.pack . F.splitDirectories . F.dropExtension