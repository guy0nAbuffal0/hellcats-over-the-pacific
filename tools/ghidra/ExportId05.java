// Headless Ghidra script: export function list for imported ID05 CODE segment.
// @category Hellcats
//
// Usage (example):
//   analyzeHeadless /tmp/hellcats-ghidra HellcatsId05 \
//     -import ID05.bin -loader BinaryLoader \
//     -processor "68000:BE:32:default" -cspec default \
//     -postScript ExportId05.java /abs/path/out.json

import ghidra.app.script.GhidraScript;
import ghidra.program.model.listing.Function;
import ghidra.program.model.listing.FunctionIterator;
import java.io.FileWriter;
import java.nio.file.Files;
import java.nio.file.Path;

public class ExportId05 extends GhidraScript {
	@Override
	public void run() throws Exception {
		String[] args = getScriptArgs();
		if (args.length < 1) {
			printerr("Usage: ExportId05.java <output.json>");
			return;
		}
		Path out = Path.of(args[0]);
		StringBuilder sb = new StringBuilder();
		sb.append("{\"program\":\"").append(currentProgram.getName()).append("\",\"functions\":[");
		boolean first = true;
		FunctionIterator it = currentProgram.getFunctionManager().getFunctions(true);
		while (it.hasNext()) {
			Function f = it.next();
			if (!first) {
				sb.append(',');
			}
			first = false;
			sb.append("{\"name\":\"").append(f.getName()).append("\",");
			sb.append("\"entry\":\"").append(f.getEntryPoint()).append("\"}");
		}
		sb.append("]}");
		Files.writeString(out, sb.toString());
		println("Wrote " + out);
	}
}
