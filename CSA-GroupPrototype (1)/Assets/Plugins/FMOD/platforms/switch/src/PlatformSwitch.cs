using System.Collections.Generic;
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif

#if UNITY_SWITCH && !UNITY_EDITOR
namespace FMOD
{
    public partial class VERSION
    {
        public const string dll = "__Internal";
    }
}

namespace FMOD.Studio
{
    public partial class STUDIO_VERSION
    {
        public const string dll = "__Internal";
    }
}
#endif

namespace FMODUnity
{
#if UNITY_EDITOR
    [InitializeOnLoad]
#endif
    public class PlatformSwitch : Platform
    {
        static PlatformSwitch()
        {
            Settings.AddPlatformTemplate<PlatformSwitch>("dc6af03a6d487a943bd07c6a5a1aafcc");
        }

        public override string DisplayName { get { return "Switch"; } }
        public override void DeclareRuntimePlatforms(Settings settings)
        {
            settings.DeclareRuntimePlatform(RuntimePlatform.Switch, this);
        }

#if UNITY_EDITOR
        public override Legacy.Platform LegacyIdentifier { get { return Legacy.Platform.Switch; } }
#endif

        public override string GetBankFolder()
        {
            string bankFolder = base.GetBankFolder();

            if (bankFolder[0] == '/')
            {
                bankFolder = bankFolder.Substring(1);
            }

            return bankFolder;
        }

#if UNITY_EDITOR
        public override IEnumerable<BuildTarget> GetBuildTargets()
        {
            yield return BuildTarget.Switch;
        }

        protected override BinaryAssetFolderInfo GetBinaryAssetFolder(BuildTarget buildTarget)
        {
            return new BinaryAssetFolderInfo("switch", "Plugins/Switch");
        }

        protected override IEnumerable<FileRecord> GetBinaryFiles(BuildTarget buildTarget, bool allVariants, string suffix)
        {
            yield return new FileRecord(string.Format("libfmodstudiounityplugin{0}.a", suffix));
        }

        protected override IEnumerable<FileRecord> GetOptionalBinaryFiles(BuildTarget buildTarget, bool allVariants)
        {
            yield return new FileRecord("libresonanceaudio.a");
        }

        protected override IEnumerable<FileRecord> GetSourceFiles()
        {
            yield return new FileRecord("fmod_switch.cs");
        }

        public override bool IsFMODStaticallyLinked { get { return true; } }

        public override OutputType[] ValidOutputTypes
        {
            get
            {
                return sValidOutputTypes;
            }
        }

        private static OutputType[] sValidOutputTypes = {
           new OutputType() { displayName = "nn::audio", outputType = FMOD.OUTPUTTYPE.NNAUDIO },
        };

        public override int CoreCount { get { return 3; } }
#endif
    }
}
