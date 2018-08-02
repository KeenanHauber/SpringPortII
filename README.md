# MacTASClient
A native MacOS client for the TASServer, a server designed for organising multiplayer games running on the [Spring Engine](https://springrts.com). The Official Server runs the [Uberserver](https://github.com/spring/uberserver). The lobbyserver protocol description may be found [here](https://springrts.com/dl/LobbyProtocol/ProtocolDescription.html). An alternative lobby client, SpringLobby (Cross-platform), may be found [here](https://github.com/springlobby/springlobby).

## Downloading binaries (the compiled application)

At this point in time, due to its extremely limited functinality, MacTASClient is not available as a compiled application. As soon as it is usable, binaries will be provided.

… somehow. 

.-. I'll work it out.

## How can you help?

Of course, the more the merrier! The Spring community is in desperate need of a functional lobby, and the more hands we have working on the task, the sooner there'll be a solution provided. 

#### Getting onboard

MacTASClient requires XCode 9 to compile. Simply clone the repository (`git clone https://github.com/MasterBel2/SpringPortII.git`) and launch `SpringPort II.xcopderoj`. 

The current development branch is `develop`. Releases will be pushed to `master`. Current efforts are being put into a complete from-scratch rebuild: this is happening in the `rebuild` branch. Contact MasterBel2 (2masterbel_gmail_com) if you are interested in helping out, or submit a pull request with details of your additions. 

Please do not submit any pull requests to the `master` branch.

#### Immediate Development Goals

Multiplayer play: 
- Viewing battle list
  - View by game
  - View battle details
  - Joining battle room
- Battleroom
  - Battleroom chat
  - Map preview, game details
  - Ingame status
Chat:
- Channels
  - Automatic join list
  - Message
- Private messaging
  - Creation of a conversation

#### Future Goals
- Multiplayer play: 
  - Viewing options
  - Autohost interface – buttons to send commands instead of 
  - Hosting battles & Replays
- Singleplayer play:
  - Custom Singleplayer games
  - Replays
- Chat
  - Mute channel
  - Ignore/block person
  - View list of channels
  - 
- Statistics & Bragging rights
  - Ingame time (update after every game)
  - Replays site: display leaderboards & usernames link to profiles/display TS profile cards (?)
  - Rank (and rank title) 
- Controls & Customisability
  - Mute notifications when ingame (to limit distractions)
  - Lobby music player (?)
  - Change nickname/password
  - Add clan tag (?)

## Current functionality of the `master` Branch
MacTASClient is limited but functional, with all work aiming to increase its functionality and usability. Currently the application can: 
- Register on and log into the lobby server
- Present battles and information (restricted to only battles with players currently)
- Join and participate in a battle
- Launch a singleplayer game

![Main window](Images/Main%20Window.png?raw=true "Main window")
![Battleroom](Images/Battleroom.png?raw=true "Battleroom")


