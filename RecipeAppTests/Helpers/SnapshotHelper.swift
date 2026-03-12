//
//  SnapshotHelper.swift
//  RecipeAppTests
//

import XCTest
import SwiftUI

// MARK: - SnapshotTestCase

/// Base class for snapshot tests. Renders SwiftUI views to PNG and compares against
/// reference images stored in `__Snapshots__/<TestClass>/` next to the test file.
///
/// First run (no reference): records the snapshot and fails the test.
/// Subsequent runs: compares against the reference and fails on mismatch.
/// Set the `RECORD_SNAPSHOTS=1` env var to force re-recording all snapshots.
class SnapshotTestCase: XCTestCase {

    /// Returns true if snapshot recording mode is active.
    var recordSnapshots: Bool {
        ProcessInfo.processInfo.environment["RECORD_SNAPSHOTS"] == "1"
    }

    /// Renders `view` at `size` and compares it against the stored reference snapshot.
    @MainActor
    func assertSnapshot<V: View>(
        of view: V,
        named name: String? = nil,
        size: CGSize = CGSize(width: 390, height: 844),
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let snapshotName = name ?? sanitizedTestName(testName)
        let snapshotDir = snapshotDirectory(for: file)
        let snapshotURL = snapshotDir.appendingPathComponent("\(snapshotName).png")

        guard let capturedData = renderView(view, size: size)?.pngData() else {
            XCTFail("Failed to render view for snapshot '\(snapshotName)'", file: file, line: line)
            return
        }

        let fileManager = FileManager.default
        let shouldRecord = recordSnapshots || !fileManager.fileExists(atPath: snapshotURL.path)

        if shouldRecord {
            do {
                try fileManager.createDirectory(at: snapshotDir, withIntermediateDirectories: true)
                try capturedData.write(to: snapshotURL)
                if !recordSnapshots {
                    XCTFail(
                        "Recorded new snapshot '\(snapshotName)'.\nPath: \(snapshotURL.path)\nRun the test again to verify.",
                        file: file, line: line
                    )
                }
            } catch {
                XCTFail("Failed to save snapshot '\(snapshotName)': \(error)", file: file, line: line)
            }
        } else {
            guard let referenceData = try? Data(contentsOf: snapshotURL) else {
                XCTFail("Failed to load reference snapshot at: \(snapshotURL.path)", file: file, line: line)
                return
            }

            if capturedData != referenceData {
                let failedURL = snapshotDir.appendingPathComponent("\(snapshotName)_failed.png")
                try? capturedData.write(to: failedURL)
                XCTFail(
                    """
                    Snapshot '\(snapshotName)' does not match reference.
                    Reference: \(snapshotURL.path)
                    Actual:    \(failedURL.path)
                    To update, run tests with RECORD_SNAPSHOTS=1 or delete the reference file.
                    """,
                    file: file, line: line
                )
            }
        }
    }

    // MARK: - Private Helpers

    /// Snapshots are stored at: <TestFile's dir>/__Snapshots__/<TestClass>/
    private func snapshotDirectory(for file: StaticString) -> URL {
        let testClass = String(describing: type(of: self))
        return URL(fileURLWithPath: file.description)
            .deletingLastPathComponent()
            .appendingPathComponent("__Snapshots__")
            .appendingPathComponent(testClass)
    }

    private func sanitizedTestName(_ name: String) -> String {
        name
            .replacingOccurrences(of: "()", with: "")
            .replacingOccurrences(of: "/", with: "_")
    }

    @MainActor
    private func renderView<V: View>(_ view: V, size: CGSize) -> UIImage? {
        let hostingController = UIHostingController(rootView: view)
        hostingController.view.frame = CGRect(origin: .zero, size: size)
        hostingController.view.backgroundColor = UIColor.white
        hostingController.view.layoutIfNeeded()

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            hostingController.view.drawHierarchy(
                in: CGRect(origin: .zero, size: size),
                afterScreenUpdates: true
            )
        }
    }
}
