{-# LANGUAGE OverloadedStrings, RecordWildCards #-}
module Lib
  (botExec) where

import Data.Text
import Pipes

import Network.Discord

reply :: Message -> Text -> Effect DiscordM ()
reply Message{messageChannel=chan} cont = fetch' $ CreateMessage chan cont Nothing

botExec :: IO ()
botExec = runBot (Bot "WOWEE THERE WAS A TOKEN HERE BUT I DONT KNOW HOW TO DO CONFIGS IN HASKELL YET!") $ do
  with ReadyEvent $ \(Init v u _ _ _) ->
    liftIO . putStrLn $ "Connected to gateway v" ++ show v ++ " as user " ++ show u

  with MessageCreateEvent $ \msg@Message{..} -> do
    when ("Ping" `isPrefixOf` messageContent && (not . userIsBot $ messageAuthor)) $
      reply msg "Pong!"
