::ModLewd <- {
	ID = "mod_lewd",
	Name = "ModLewd",
	Version = "1.0.0"
}
::mods_registerMod(::ModLewd.ID, ::ModLewd.Version, ::ModLewd.Name);

::mods_queue(::ModLewd.ID, null, function()
{
	::ModLewd.Mod <- ::MSU.Class.Mod(::ModLewd.ID, ::ModLewd.Version, ::ModLewd.Name);
	::mods_registerJS("./mods/ModLewd/index.js");
	::mods_registerCSS("./mods/ModLewd/index.css");
})