--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

ACC2 = ACC2 or {}
ACC2.ScrW, ACC2.ScrH = ScrW(), ScrH()

function ACC2.LoadFonts()
	surface.CreateFont("ACC2:Font:01", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.07,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
		rotary = false,
	})

	surface.CreateFont("ACC2:Font:02", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.07,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		italic = true,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:03", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.035,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		italic = true,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:04", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.022,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:05", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.049,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:06", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.036,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		italic = true,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:07", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.028,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		italic = true,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:08", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.024,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		italic = true,
		antialias = true,
	})
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466944 */

	surface.CreateFont("ACC2:Font:09", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.026,
		italic = false,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:10", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.033,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:11", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.045,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:12", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.024,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		italic = false,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:13", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.04,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823

	surface.CreateFont("ACC2:Font:14", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.025,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		italic = true,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:15", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.026,
		italic = false,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:16", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.02,
		italic = false,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:17", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.026,
		italic = false,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:18", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.026,
		italic = false,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:19", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.026,
		italic = false,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:20", {
		font = "Roboto",
		extended = true,
		size = 165,
		italic = false,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:21", {
		font = "Roboto",
		extended = true,
		size = 47,
		italic = false,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466944 */

	surface.CreateFont("ACC2:Font:22", {
		font = "Roboto",
		extended = true,
		size = 55,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:23", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.045,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:24", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.028,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		italic = true,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:25", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.021,
		italic = false,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("ACC2:Font:26", {
		font = "Roboto",
		extended = true,
		size = ACC2.ScrH*0.021,
		italic = false,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
end


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
