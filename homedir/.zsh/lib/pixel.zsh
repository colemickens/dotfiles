pixel_speakers() {
	amixer -c 0 cset name='DAC1 MIXL DAC1 Switch' on
	amixer -c 0 cset name='DAC1 MIXR DAC1 Switch' on

	amixer -c 0 cset name='Headphone Switch' off
	amixer -c 0 cset name='Stereo DAC MIXL DAC1 L Switch' off
	amixer -c 0 cset name='Stereo DAC MIXR DAC1 R Switch' off
	amixer -c 0 cset name='Stereo DAC MIXL DAC1 R Switch' on
	amixer -c 0 cset name='Stereo DAC MIXR DAC1 L Switch' on
	amixer -c 0 cset name='Speaker Switch' on
}

pixel_headphones() {
	amixer -c 0 cset name='DAC1 MIXL DAC1 Switch' on
	amixer -c 0 cset name='DAC1 MIXR DAC1 Switch' on

	amixer -c 0 cset name='Speaker Switch' off
	amixer -c 0 cset name='Stereo DAC MIXL DAC1 R Switch' off
	amixer -c 0 cset name='Stereo DAC MIXR DAC1 L Switch' off
	amixer -c 0 cset name='Stereo DAC MIXL DAC1 L Switch' on
	amixer -c 0 cset name='Stereo DAC MIXR DAC1 R Switch' on
	amixer -c 0 cset name='OUT1 Playback Switch' on
	amixer -c 0 cset name='OUT2 Playback Switch' on
	amixer -c 0 cset name='Headphone Switch' on
}

