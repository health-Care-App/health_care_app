package gpt

type Message struct {
	Question string `json:"question" validate:"required"`
	//ずんだもんの場合0, 春日部つむぎの場合1
	Model int `json:"model" validate:"min=0,max=1"`
}
