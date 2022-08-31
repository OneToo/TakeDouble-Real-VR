Quick setup
Installation is very simple.

You'll need the Remastered version of the game. Any store should do, not just Steam, but older/discontinued versions like the "Prepare to Die" edition will not work with my mod;
make sure the game was run flat (without VR) at least once, so that it had a chance to create your user profile;
unzip the mod archive attached at the bottom of this post into the "DARK SOULS REMASTERED" folder where "DarkSoulsRemastered.exe" is, being careful to preserve the folder structure (i.e., don't move anything around manually, don't flatten the folders, and don't put the mod into its own subfolder: RealConfig.bat must end up at the same level as DarkSoulsRemastered.exe);
lastly run RealConfig.bat, which will install the mod and automatically configure the game to use suitable graphics options. If the batch file gives you any errors, please copy them down and include them in your comment.

Graphics settings
This game doesn't offer many settings to tweak (and it doesn't really need to, because performance is already excellent). RealConfig will give you defaults known to work well in VR. As usual with my mods, do not change the Display mode from Windowed and always leave Vertical sync and Motion Blur set to OFF. You can tweak everything else, although my personal recommendation is to set Anti-Aliasing to "FXAA High" (in this game we're not forced to use TAA, yay!), Depth of field to OFF, Ambient Occlusion to ON.

The most important parameter you might want to change depending on your system is the Display Resolution. RealConfig sets it to a default of 2432x2432. If you have a powerful GPU however, you can push it much higher while still hitting the magical 180 fps figure! To be precise, the crucial number of frames per second where the game will look perfectly native is twice the headset refresh frequency, so if you have a Quest 2 with default settings your target frame rate will be 144 fps, even easier to achieve.

Interface
Similarly to my Elden Ring VR conversion, this mod for DS:R implements my new Quick Menu system:



You can bring it up at all times during gameplay by pressing Back+Start on the controller (Select+Start with a PS-style gamepad) or Pause on the keyboard. Note for returning users: there is no "double trigger" gesture for this game.

The Quick Menu behaves in a very special way: it will freeze action while it's open (something the original game never allows you to do, not even while you're navigating its own menus) and it will immediately react to buttons or stick actions on the gamepad. Basically it's meant to be a collection of shortcuts that lets you make the most important changes to the VR mod configuration instantly, especially when muscle memory has set in and your fingers already know where to go, without navigating complex menus and breaking the flow of the game.

You can still access the traditional R.E.A.L. VR mod overlay, either by pressing A or Cross when in the Quick Menu, or by double-clicking on Back+Start instead of single-clicking. The full overlay is needed if you want to set the automatic save backup interval for example, or change the world scale.

As you can see in the picture above, from the Quick Menu you can do all sorts of things like:

removing the overlay itself while keeping the game frozen, to take your time observing epic moments in the action from any perspective in full roomscale;
enabling/disabling tourist mode (NPCs, dragons and other fantastic creatures won't ever bother you);
selecting your favorite VR render mode, in case your GPU is really old and you need to scale down to AER or even Mono rendering;
fine-tuning the camera positions (more below on the various cameras I implemented);
finally, the Quick Menu gives you full control over the game speed. This is even more powerful than in Elden Ring's case, because this time you can slow down the enemies while preserving full speed for your character. Remember that with great power comes great responsibility, so don't abuse it, hehe.
Special VR cameras
Like other Souls games, the original flat version of DS:R only has one distant camera, which usually hovers about 3-5 meters behind your character and can get even farther during combat or fast movement; the original camera also has the peculiarity of shooting up in the sky whenever you get close to a locked-on enemy, which I find extremely annoying in VR because it forces you to look down toward your feet to see the action, as if you were sitting on a drone.

I left it in for purists (although you can fine tune its position using the offsets shown in the Quick Menu), but the default for the VR mod is my "Closer" camera, which is about half the distance and won't swing up wildly every time you approach enemies.

Then, if you want to actually be in the thick of action, there is the "R.E.A.L. close" camera, which gives you an over-the-shoulder view that allows you to see everything without feeling left behind.

And last but not least, I implemented a full first-person camera, which can be selected at all times; I didn't make it the default choice however, because it's not for the faint of stomach! It is actually attached to the character's head, so it will react to everything the character does: jumping, crouching, rolling (the horizon will stay level though, like in my Elden Ring mod). It really transports you into the Dark Souls world. As you can see from Beardo Benjo's video above, the first person camera also implements my new smoothing system to automatically get rid of head bobbing.

An important reminder if you want to play in first person: since your in-game character can be customized in many different ways, and equipped with all kinds of armor and helmets, it is quite possible that the first person camera might not be in the perfect place for you. That's what the customizable offsets are for. You can fine tune each camera so that it's in your favorite position and it won't clip into anything; the offsets will be remembered when you switch cameras and also across different game sessions.

Presets
Just like Elden Ring, my previous conversion, Dark Souls: Remastered relies on very fast combat, with a lot of rolling/dodging and wild camera movements. That's why this release also supports Presets, the final element of the Quick Menu. There are 4 independent presets, which can be fully customized by the user. For every preset you can select tourist mode on/off, control the game speed, choose the camera type and the render mode.

With my defaults, the presets are intended for the following functions:

Up is for normal gameplay and light combat, with 1x game speed and the "Closer" camera that IMO works much better than the original one in VR;
Left is for fully-immersive exploration in first person and possibly light combat too, if you have strong VR legs and can tolerate sudden camera movements;
Right is for intense combat, like boss fights or situations where you're surrounded by enemies; it will give you a more comfortable perspective from the "Closer" point of view, and it will slow down time to 0.75x to keep you from being overwhelmed, while at the same time keeping the action fluid even on PCs that cannot sustain a good enough frame rate at full speed;
Down is for the most relaxing and immersive exploration in first person, with "Tourist" mode active so nobody will bother you :-)
Again, the presets (like everything else in the Quick Menu) are meant for instant access, as if they were combos: for example, if you're exploring in first person with the "Left" preset and suddenly find yourself attacked by a huge monster, the three-button combo Back+Start -> D-Pad Right will immediately slow down time and bring you to a more comfortable position behind your character.

Slow (or fast!) motion

If you want to turn your boss fights into epic slow-motion affairs, where you have all the time you need to study the adversary and choose your strategies, while simultaneously taking in every detail of the models and animations, you can customize a preset so that it uses the first person camera (perhaps in Mono mode for maximum fluidity even on weaker GPUs) at a time scale of around 0.2x to 0.5x. Or if you're a veteran of the series and want to be punished even harder, you can also set the speed to higher than 1x for an insane challenge ^_^

AER vs R.E.A.L.

All my mods use AER (Alternate Eye Rendering). Despite what some people believe, that is not a philosophical or religious choice, or one I made because I'm lazy, but one of necessity :-)

I specialize in converting huge, open-world games (like GTA V, RDR2, Cyberpunk 2077, ...) that even on modern top-end hardware often struggle to keep a steady 60 fps frame rate. And that's in 2D, in the original configuration the games were designed to run on, and with resolutions up to 4K or 8 megapixels.

VR needs at least the same resolutions (different aspect ratio, but about 8 megapixels or more depending on the headset) with the added complication that the view must be rendered twice, for the left and right eye, and with the stringent requirement that frame rate must never go below 45 fps and should really stay around a minimum of 70-80 fps for a good experience.

So, on one side we have the original 2D games barely hitting 60 fps total, and on the VR side we need at least 70-80 fps per eye, so 140-160 fps total, and we'd also like to be pushing higher resolutions.

It should be self-evident that, no matter how good a modder's skills or how vast the amount of coding time invested, there is a physical impossibility in taking a game that runs at 60 fps total and magically making it churn out more than double that frame rate, even discounting the fact that VR inevitably adds some overhead and that resolution might need to be even higher.

To solve that paradox without dumbing down the game graphics horribly, I decided since my first GTA V mod to adopt the alternate eye rendering (AER) technique. In a nutshell, what I do is have the game render alternate views (left eye, then right eye, then left again and so on) and reproject the eye which is not being rendered at any given time. That gets rid of the 2x factor, because with AER 70-80 fps total are equivalent to 70-80 fps per eye (you no longer need 140-160 as the missing frames are being reprojected).

If your system is configured and running correctly, the only disadvantage of AER is that objects/characters in strong lateral motion exhibit a sort of border doubling that we call ghosting. It's an illusion (in fact it cannot be captured on video, not even through the headset lenses) caused by the double flashing of the same image, when the brain would expect a smooth frame-by-frame movement. Most people learn to "unsee" it pretty quickly, and as with all visual defects, it will bother you the most if you dwell on it. If you concentrate on enjoying gameplay (and again, unless you have some other problem on your system which is making the renderer work incorrectly) it should rapidly fall below your threshold of perception.

That said, it's important to understand that the issue is not an intrinsic fault of alternate eye rendering: it is strictly caused by the game engine not being able to sustain a high enough frame rate. One of the reasons why I chose the Dark Souls: Remastered title for this new mod is that it clearly demonstrates this fact, because its engine is both very well written and old enough to finally deliver the 180 fps (or twice the headset refresh rate, so 144 fps for a Quest 2 in the default configuration) that are needed for alternate eye rendering to work without reprojection. As you will see, the game looks perfectly "native", and there are no ghosting artifacts whatsoever.

This hopefully should also dispel the myth that simultaneous frame rendering (i.e., freezing game time between the rendering of the left and right eye) is necessary for VR to look correct. When the engine is capable of full frame rate, and no reprojections are needed, the AER tech that I also use in this Dark Souls: Remastered mod is indistinguishable from simultaneous rendering. As a side note for developers: even when reprojection is required due to low fps, simultaneous frame rendering is not a good idea because all it does is increase the latency of one eye by the amount of wall-clock time that you have to wait until the frame for the other eye has finished rendering.

Finally, you will notice that this 5.0.1. release defaults to "R.E.A.L." instead of "Stereo (AER)"; this mode was already available for my earlier mods, but it wasn't set as the default, and several people asked me what the difference was and how to determine the best configuration.

"R.E.A.L." mode (in the context of my work) simply means AER but without a half-rate cap. In VR there is implicit and compulsory v-sync to the headset refresh frequency, not for a technical limitation, but because Oculus and Valve decided that there should never be tearing in the images shown by the HMD. So if your headset is refreshed at 90 Hz, the game will never be allowed to render more than 90 fps per eye, which is equivalent (as we discussed) to 180 fps total if you want zero reprojection, or 90 fps or less if you reproject the eyes alternatively.

With the "Stereo (AER)" mode, my mod will limit/cap the game engine fps to the headset refresh frequency (always forcing alternate eye reprojection), so that the ghosting artifacts have the same width every frame and the amount of stuttering is kept down to a minimum. That helps the brain tune out the effect, because we're very good at ignoring repetitive stimuli.

With a game engine that can approach or exceed double the refresh rate (144-180 fps) however, it makes no sense to force reprojection, and it's better instead to allow the engine to render as fast as it can. That's what the "R.E.A.L." mode does.

TL;DR: for games that can barely hit 72-90 fps as measured by the mod internal frame rate counter, it's best to set the Render mode to "Stereo (AER)" because the artifacts from alternate eye rendering will look more regular and will be easier for the brain to adapt to. For games that can render at much higher speeds (144-180 fps) it's best to select "R.E.A.L." because the artifacts from alternate eye rendering will disappear completely as you approach double the headset frequency.

