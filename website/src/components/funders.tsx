export default function Funders() {
  return (
    <>
      <div className="lg:flex lg:mx-18 lg:p-8  lg:flex-row items-center lg:gap-5 flex flex-col gap-2 lg:justify-between dark:bg-white rounded-xl mx-10">
        <div className="w-[22%] aspect-3/2 object-contain">
          <img src="/logos/uon.png" alt="Logo UoN" />
        </div>
        <div className="w-[30%] aspect-3/2 object-contain">
          <img src="/logos/nihr-nbrc.png" alt="Logo CCN" />
        </div>
        <div className="w-[18%] aspect-3/2 object-contain">
          <img src="/logos/hdr.png" alt="Logo UKRI" />
        </div>
        <div className="w-[15%] aspect-3/2 object-contain">
          <img src="/logos/sde.png" alt="Logo ALVE" />
        </div>
      </div>
    </>
  );
}
