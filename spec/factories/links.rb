FactoryGirl.define do
  factory :link, class: ZooqleSearch::Link do
    params {{
      'name'         => 'Suits%20S05E16%20HDTV%20x264-KILLERS%5Bettv%5D',
      'extension'    => 'mp4',
      'magnet'       => 'magnet:?xt=urn:btih:F0686728B98BBFF1B07AFCAC73620E2FBC200F4B&dn=suits+s05e16+hdtv+x264+killers+ettv&tr=udp%3A%2F%2Ftracker.publicbt.com%2Fannounce&tr=udp%3A%2F%2Fglotorrents.pw%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80%2Fannounce',
      'seeders'      => '111',
      'leechers'     => '999',
      'download_url' => '//torcache.net/torrent/F0686728B98BBFF1B07AFCAC73620E2FBC200F4B.torrent?title=[kat.cr]suits.s05e16.hdtv.x264.killers.ettv'
    }}

    initialize_with { new(params) }
  end
end
