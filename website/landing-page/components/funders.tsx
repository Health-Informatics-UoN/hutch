export default function Funders() {
  return (
    <>
      <div className="lg:flex lg:mx-36 lg:flex-row items-center lg:gap-5 flex flex-col gap-2 lg:justify-between dark:bg-white rounded-xl mx-10">
        <div className="w-[20%] aspect-3/2 object-contain filter grayscale">
          <img src="/logos/uon.png" alt="Logo UoN" />
        </div>
        <div className="w-[24%] aspect-3/2 object-contain filter grayscale">
          <img src="/logos/bc-black.png" alt="Logo CCN" />
        </div>
        <div className="w-[15%] aspect-3/2 object-contain filter grayscale">
          <img src="/logos/hdr-black.png" alt="Logo UKRI" />
        </div>
        <div className="w-[22%] aspect-3/2 object-contain filter grayscale">
          <img src="/logos/sde-black.png" alt="Logo ALVE" />
        </div>
      </div>
    </>
  );
}
