"use client";
import {useEffect,useMemo,useState} from "react";
import {supabase} from "@/lib/supabase";
type Item={id:string;sku:string;name:string;category:string;description:string|null;size:string|null;price:number|null;status:string;image_url:string|null;included:string|null};
const cats=["Semua","Melayu","Dayak","Jawa","Bali","Nusantara Lainnya"];
const wa=process.env.NEXT_PUBLIC_WHATSAPP_NUMBER||"6289521032797";
export default function Home(){
 const [items,setItems]=useState<Item[]>([]),[cat,setCat]=useState("Semua"),[q,setQ]=useState(""),[loading,setLoading]=useState(true);
 useEffect(()=>{supabase.from("collections").select("*").eq("is_published",true).order("created_at",{ascending:false}).then(({data})=>{setItems((data||[]) as Item[]);setLoading(false)})},[]);
 const shown=useMemo(()=>items.filter(x=>(cat==="Semua"||x.category===cat)&&(`${x.name} ${x.sku} ${x.description||""}`).toLowerCase().includes(q.toLowerCase())),[items,cat,q]);
 return <><header className="top"><div className="wrap"><div className="brand">NUSSA</div><div className="eyebrow">Busana Adat Nusantara · Pontianak</div></div></header>
 <main className="wrap"><section className="hero"><div className="eyebrow">Koleksi Busana Adat</div><h1>Kenakan Warisan Budaya</h1><p>Temukan busana adat untuk momen istimewa Anda. Jelajahi koleksi NUSSA dan hubungi admin untuk informasi ukuran, ketersediaan, serta pemesanan.</p></section>
 <div className="filters">{cats.map(c=><button key={c} className={cat===c?"active":""} onClick={()=>setCat(c)}>{c}</button>)}</div>
 <input className="search" placeholder="Cari nama atau kode koleksi..." value={q} onChange={e=>setQ(e.target.value)}/>
 {loading?<p style={{textAlign:"center",padding:50}}>Memuat koleksi...</p>:shown.length===0?<p style={{textAlign:"center",padding:50}}>Belum ada koleksi yang ditampilkan.</p>:<div className="grid">{shown.map(x=><article className="item" key={x.id}>{x.image_url?<img src={x.image_url} alt={x.name}/>:<div style={{height:300,display:"grid",placeItems:"center",color:"#999"}}>Foto belum tersedia</div>}<div className="itembody"><div className="tag">{x.category} · {x.sku}</div><h3>{x.name}</h3>{x.description&&<p className="muted">{x.description}</p>}{x.size&&<p className="muted">Ukuran: {x.size}</p>}{x.included&&<p className="muted">Kelengkapan: {x.included}</p>}{x.price!==null&&<div className="price">Rp{Number(x.price).toLocaleString("id-ID")}</div>}<div className={x.status==="Tersedia"?"status":"status off"}>{x.status}</div><p><a className="wa" target="_blank" rel="noreferrer" href={`https://wa.me/${wa}?text=${encodeURIComponent(`Halo Admin NUSSA, saya tertarik menyewa ${x.name} (${x.sku}). Mohon informasi lebih lanjut.`)}`}>Tanya via WhatsApp</a></p></div></article>)}</div>}</main>
 <footer className="footer"><div className="brand">NUSSA</div><p>Busana Adat Nusantara · Pontianak</p><a className="wa" target="_blank" rel="noreferrer" href={`https://wa.me/${wa}?text=${encodeURIComponent("Halo Admin NUSSA, saya ingin bertanya tentang penyewaan baju adat.")}`}>WhatsApp Admin</a></footer></>;
}
