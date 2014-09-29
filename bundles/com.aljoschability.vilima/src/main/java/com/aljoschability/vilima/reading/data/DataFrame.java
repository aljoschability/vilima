package com.aljoschability.vilima.reading.data;

public class DataFrame {
	public int trackNumber;
	public long timecode;
	public long duration;
	public long reference;
	private long[] references;
	public byte[] data;
	public boolean keyFrame;

	public DataFrame() {
		System.err.println("new " + this);
	}

	public DataFrame(DataFrame copy) {
		System.err.println("new_copy " + this);

		this.trackNumber = copy.trackNumber;
		this.timecode = copy.timecode;
		this.duration = copy.duration;
		this.reference = copy.reference;
		this.keyFrame = copy.keyFrame;
		if (copy.references != null) {
			this.references = new long[copy.references.length];
			System.arraycopy(copy.references, 0, this.references, 0, copy.references.length);
		}
		if (copy.data != null) {
			this.data = new byte[copy.data.length];
			System.arraycopy(copy.data, 0, this.data, 0, copy.data.length);
		}
	}
}
