// SPDX-License-Identifier: GPL-2.0-only
/*
 * Driver for the bare codec based on the pcm5102a driver
 *
 * Author:	Matt Flax <flatmax@>
 *		Copyright 2022
 */

#include <linux/init.h>
#include <linux/module.h>
#include <linux/platform_device.h>

#include <sound/soc.h>

static struct snd_soc_dai_driver bare_dai = {
	.name = "bare-hifi",
	.playback = {
		.channels_min = 2,
		.channels_max = 2,
		.rates = SNDRV_PCM_RATE_192000,
		.formats = SNDRV_PCM_FMTBIT_S16_LE |
			   SNDRV_PCM_FMTBIT_S24_LE |
			   SNDRV_PCM_FMTBIT_S32_LE
	},
	.capture = {
		.channels_min = 2,
		.channels_max = 2,
		.rates = SNDRV_PCM_RATE_192000,
		.formats = SNDRV_PCM_FMTBIT_S16_LE |
			   SNDRV_PCM_FMTBIT_S24_LE |
			   SNDRV_PCM_FMTBIT_S32_LE
	},
};

static struct snd_soc_component_driver soc_component_dev_bare = {
	.idle_bias_on		= 1,
	.use_pmdown_time	= 1,
	.endianness		= 1,
	.non_legacy_dai_naming	= 1,
};

static int bare_probe(struct platform_device *pdev)
{
	return devm_snd_soc_register_component(&pdev->dev, &soc_component_dev_bare,
			&bare_dai, 1);
}

static const struct of_device_id bare_of_match[] = {
	{ .compatible = "flatmax,bare", },
	{ }
};
MODULE_DEVICE_TABLE(of, bare_of_match);

static struct platform_driver bare_codec_driver = {
	.probe		= bare_probe,
	.driver		= {
		.name	= "bare-codec",
		.of_match_table = bare_of_match,
	},
};

module_platform_driver(bare_codec_driver);

MODULE_DESCRIPTION("ASoC bare codec driver");
MODULE_AUTHOR("Matt Flax <flatmax@>");
MODULE_LICENSE("GPL v2");
