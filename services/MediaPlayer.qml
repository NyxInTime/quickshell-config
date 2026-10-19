pragma Singleton

import Quickshell.Services.Mpris
import Quickshell

//TODO refactor this entire element, as well as the entire media tab of dashboard to be able to use more than just spotify
//For now, this just uses spotify, since that is what I use, while it should be able to switch between whichever ones you have.
Singleton {
    // TODO make the active player switch if the current active player no longer exists.
    property list<MprisPlayer> players: Mpris.players.values
    property var activeSpotifyPlayer: players.filter(player => isSpotify(player))[0] ?? null
    property MprisPlayer activePlayer: players[0]

    function isSpotify(player) {
        return player.dbusName === "org.mpris.MediaPlayer2.spotify" ? player : nothing();
    }
    function nothing() {
    }
}
