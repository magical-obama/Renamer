using System.IO.Compression;
using System.Text.RegularExpressions;
using System.Xml.Linq;

internal class Program
{
    private static void Main(string[] args)
    {
        const string DEFAULT_AUTHOR = "Unbekannt";

        // Console.WriteLine(args[0]);

        if (args.Length < 1 || !FileOrDirExists(args[0]))
        {
            CancelExecWithError("Couldn't find file/directory to process or it does not exist.");
        }

        FileAttributes attr = File.GetAttributes(args[0]);

        if (!IsDirectory(attr))
        {
            Console.WriteLine("Detected a file. Renaming...");
            string tempDir = GetTempDir();
            RenameFile(args[0], tempDir);
            Console.WriteLine("Deleting temporary directories...");
            Directory.Delete(tempDir, true);
        } else {
            Console.WriteLine("Detected a directory. Renaming all files...");
            string tempDir = GetTempDir();
            foreach (string fileName in Directory.GetFiles(args[0]))
            {
                RenameFile(fileName, tempDir);
            }
            Console.WriteLine("Deleting temporary directories...");
            Directory.Delete(tempDir, true);
        }

        

        static void RenameFile(string fileName, string tempDir)
        {
            // Console.WriteLine(Path.GetFullPath(tempDir));

            if (!File.Exists(fileName) || IsDirectory(File.GetAttributes(fileName)))
            {
                CancelExecWithError("Couldn't find the input file.");
            }

            FileInfo info = new FileInfo(fileName);
            if (!(info.FullName.EndsWith(".docx") || info.FullName.EndsWith(".xlsx") || info.FullName.EndsWith(".pptx")))
            {
                Console.Error.WriteLine("File is not a Office document, skipping...");
                return;
            }

            ZipArchive zipArchive;
            try
            {
                zipArchive = ZipFile.OpenRead(fileName);
            } catch (Exception)
            {
                // Console.Error.WriteLine(ex);
                Console.Error.WriteLine("Couldn't read compressed file, skipping file...");
                return;
            }

            string author = DEFAULT_AUTHOR;

            // string tempDir = GetTempDir();
            // Console.WriteLine(tempDir);

            zipArchive.ExtractToDirectory(tempDir, true);
            zipArchive.Dispose();

            XElement coreProps = XElement.Load(Path.Combine(tempDir, "docProps/core.xml"));
            // Console.WriteLine(coreProps.Name);

            try {
                // IEnumerable<XElement> creatorTags = coreProps.Descendants(dc + "creator");
                // Console.WriteLine(creatorTags.Count());
                author = coreProps.Descendants("{http://purl.org/dc/elements/1.1/}creator").First().Value;
                // author = coreProps.Descendants("dc:creator").First().Value;
                // Console.WriteLine("Name: " + coreProps.Descendants("{dc}creator").First().Name + " Value: " + author);
            } catch (Exception)
            {
                // Console.Error.WriteLine(ex);
                Console.Error.WriteLine("Couldn't find author name from doc, default name used...");
            }

            // Console.WriteLine(author);

            if (String.IsNullOrEmpty(author))
            {
                Console.Error.WriteLine("Couldn't find author name from doc, default name used...");
                author = DEFAULT_AUTHOR;
            }

            // string[] nameParts = info.Name.Split(".");
            string baseFileName = Path.GetFileNameWithoutExtension(fileName);
            // string extension = nameParts[nameParts.Length - 1];
            string extension = Path.GetExtension(fileName);

            if (baseFileName.EndsWith("von " + author))
            {
                Console.Error.WriteLine("File already renamed, skipping...");
                return;
            }

            string newFileName = Path.Combine(Path.GetDirectoryName(fileName)!, baseFileName + " von " + author + extension);

            File.Move(Path.GetFullPath(fileName), newFileName);

            if (File.Exists(newFileName))
            {
                Console.WriteLine(Path.GetFileName(fileName) + "-->" + Path.GetFileName(newFileName));
            } else
            {
                Console.Error.WriteLine("Couldn't rename file: {0}!", Path.GetFileName(fileName));
            }
         }


        static void CancelExecWithError(string errMsg)
        {
            Console.Error.WriteLine(errMsg);
            Environment.Exit(-1);
        }

        static bool IsDirectory(FileAttributes attributes)
        {
            return (attributes & FileAttributes.Directory) == FileAttributes.Directory;
        }

        static string GetTempDir()
        {
            string tempDir = Path.Combine(Path.GetTempPath(), Path.GetRandomFileName());
            Directory.CreateDirectory(tempDir);
            return tempDir;
        }

        static bool FileOrDirExists(string path)
        {
            return (Directory.Exists(path) || File.Exists(path));
        }
    }
}