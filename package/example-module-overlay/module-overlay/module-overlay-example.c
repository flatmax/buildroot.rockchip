/*
 * Example Driver
 *
 *  Created on: 14-01-2021
 *      Author: matt@audioinjector.net
 *              based on the Audio Injector Pi soundcard driver (audioinjector-pi-soundcard.c)
 *
 * Copyright (C) 2016-2021 Flatmax Pty. Ltd.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * version 2 as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 */

#include <linux/module.h>
#include <linux/types.h>
#include <linux/platform_device.h>
#include <linux/of_device.h>
#include <linux/of_platform.h>

#include <linux/version.h>
#if LINUX_VERSION_CODE >= KERNEL_VERSION(5,10,0)
#include <linux/mod_devicetable.h>
#endif

static const struct of_device_id module_overlay_of_match[] = {
	{ .compatible = "ai,audioinjector-example", },
	{},
};
MODULE_DEVICE_TABLE(of, module_overlay_of_match);

static struct platform_driver module_overlay_driver = {
	.driver         = {
		.name   = "module-overlay",
		.owner  = THIS_MODULE,
		.of_match_table = module_overlay_of_match,
	},
//	.probe          = module_overlay_probe,
};

module_platform_driver(module_overlay_driver);
MODULE_AUTHOR("Matt Flax <flatmax@>");
MODULE_AUTHOR("Matt <matt@audioinjector.net>");
MODULE_DESCRIPTION("buildroot.rockchip module overlay example");
MODULE_LICENSE("GPL v2");
MODULE_ALIAS("platform:module-overlay-rk3308");
