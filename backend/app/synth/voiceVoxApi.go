package synth

import (
	"errors"
	"io"
	"net/http"
	"os"
	"strconv"
)

// WEB版VOICEVOX API（高速）
// https://voicevox.su-shiki.com/su-shikiapis/
func VoiceVoxApiSynth(ttsText TtsText) ([]byte, error) {
	apiKey, isExist := os.LookupEnv("VOICEVOX_TOKEN")
	if !isExist {
		return nil, errors.New("VOICEVOX_TOKEN not exist")
	}

	pitch := speechPitch
	speakerId := strconv.Itoa(int(ttsText.SpeakerId))
	speed := strconv.FormatFloat(speechspeed, 'f', 2, 64)
	text := ttsText.Text
	url := `https://deprecatedapis.tts.quest/v2/voicevox/audio/?key=` + apiKey + `&speaker=` + speakerId + `&pitch=` + pitch + `&intonationScale=1&speed=` + speed + `&text=` + text

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	bytes, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	return bytes, nil
}
