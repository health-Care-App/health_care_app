package synth

const (
	accelerationMode = 0 //cpuは1, gpuは2, 0はその環境で最適なモードを選択
	cpuNumThreads    = 1 //「cpu_numhreadsが未指定または0」の場合は、「論理コア数の半分」の値を渡す
	loadAllModels    = false
	openJtalkDictDir = `/app/voicevox_core/open_jtalk_dic_utf_8-1.11`

	speechspeed = 1.05
	speechPitch = "0"
	kana        = false

	enableInterrogativeUpspeak = true
)
