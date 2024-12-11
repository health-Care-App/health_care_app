package chat

import "errors"

// chatGPTの出力エラー
var (
	errGptTagMissMatch  = errors.New(`gpt gave incorrect output: first and last tags don't match`)
	errGptSpeakerId     = errors.New(`gpt gave incorrect output: invalid speakerId`)
	errGptTextMissMatch = errors.New(`gpt gave incorrect output: text doesn't match the pattern`)
)

// geminiの出力エラー
var (
	errGeminiTagMissMatch  = errors.New(`gemini gave incorrect output: first and last tags don't match`)
	errGeminiSpeakerId     = errors.New(`gemini gave incorrect output: invalid speakerId`)
	errGeminiTextMissMatch = errors.New(`gemini gave incorrect output: text doesn't match the pattern`)
)
