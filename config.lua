--calculate the aspect ratio of the device:
local aspectRatio = display.pixelHeight / display.pixelWidth

application = {
        content = {
            graphicsCompatibility = 1,
            width = 1080, --or math.ceil( 1920 / aspectRatio ),
            height = 1920,--or math.ceil( 1080 * aspectRatio ),
            scale = "zoomEven",
            fps = 60,

            imageSuffix = {
                 ["@2x"] = 2.0,
                ["@4x"] = 4.0,
            },
        },
   license = {
      google = {
         key = "reallylonggooglelicensekeyhere",
         policy = "serverManaged", 
      },
   },
}
