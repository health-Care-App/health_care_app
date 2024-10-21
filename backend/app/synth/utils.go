package synth

import "encoding/base64"

func TextToBase64(isSynth bool, ttsText TtsText) (string, error) {
	var base64Data string
	//リクエストパラメータ"is_synth"がtrueの場合音声合成を行う
	if isSynth {
		audio, err := VoiceVoxApiSynth(ttsText)
		if err != nil {
			return "", err
		}
		base64Data = base64.StdEncoding.EncodeToString(audio.Audiobytes)
	} else {
		//音声合成を行わない場合空文字を返す
		base64Data = ""
	}
	return base64Data, nil
}
