#! swift

import Foundation

let requiredFields = ["byr", "ecl", "eyr", "hcl", "hgt", "iyr", "pid"].sorted()
let eyeColors = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

let fileContents = try String(contentsOfFile: "input.txt")
let records = fileContents.components(separatedBy: "\n\n").map { (record: String) -> [String: String] in
  record
    .replacingOccurrences(of: "\n", with: " ")
    .components(separatedBy: " ")
    .map { (pair: String) -> [String] in pair.components(separatedBy: ":") }
    .filter { $0[0] != "" }
    .reduce(into: [String: String]()) { $0[$1[0]] = $1.count > 1 ? $1[1] : "" }
}

var validRecords = 0
records.forEach {
  let requiredKeys = $0.keys.sorted().filter { $0 != "cid" }
  if requiredKeys == requiredFields {
    validRecords += 1
  }
}
print("Part 1")
print("Valid Records: \(validRecords)")
print("Total Records: \(records.count)")

validRecords = 0
records.forEach {
  let byr = Int($0["byr", default: "0"]) ?? 0
  let eyr = Int($0["eyr", default: "0"]) ?? 0
  let iyr = Int($0["iyr", default: "0"]) ?? 0
  let hgt = $0["hgt", default: ""]
  let hcl = $0["hcl", default: ""]
  let ecl = $0["ecl", default: ""]
  let pid = $0["pid", default: ""]

  let validByr = byr >= 1920 && byr <= 2002
  let validEyr = eyr >= 2020 && eyr <= 2030
  let validIyr = iyr >= 2010 && iyr <= 2020
  let validHcl = hcl.range(of: "^#[0-9a-f]{6}$", options: .regularExpression) != nil
  let validEcl = eyeColors.contains(ecl)
  let validPid = pid.range(of: "^[0-9]{9}$", options: .regularExpression) != nil
  var validHgt = false

  if hgt.suffix(2) == "cm" && hgt.count == 5 {
    let x = Int(hgt.prefix(3)) ?? 0
    validHgt = x >= 150 && x <= 193
  } else if hgt.suffix(2) == "in" && hgt.count == 4 {
    let x = Int(hgt.prefix(2)) ?? 0
    validHgt = x >= 59 && x <= 76
  }

  if validByr && validEyr && validIyr && validHcl && validHgt && validEcl && validPid {
    validRecords += 1
  } else {
  }
}

print("Part 2")
print("Valid Records: \(validRecords)")
print("Total Records: \(records.count)")
